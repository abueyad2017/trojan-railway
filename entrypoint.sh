#!/bin/bash

# 1. جلب اسم النطاق (Host) تلقائياً من Railway إذا لم يكن موجوداً
if [ -z "$RAILWAY_PUBLIC_DOMAIN" ]; then
    HOST="localhost"
else
    HOST=$RAILWAY_PUBLIC_DOMAIN
fi

# 2. توليد الشهادات الأمنية صامتة
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=$HOST" > /dev/null 2>&1

# 3. إنشاء ملف إعدادات الهيستريا (Hysteria2)
cat > config.yaml <<EOF
listen: :$PORT
tls:
  cert: cert.pem
  key: key.pem
auth:
  type: password
  password: "${PASSWORD:-abu_eyad_2026}"
EOF

# 4. حقن القيم مباشرة في صفحة الويب (مثلما فعل نورث فليك)
# هنا نقوم بتبديل الكلمات المحجوزة في index.html بالقيم الحقيقية
sed -i "s|{{PASSWORD}}|${PASSWORD:-abu_eyad_2026}|g" index.html
sed -i "s|{{HOST}}|$HOST|g" index.html

# 5. تشغيل واجهة الويب (المنفذ 8080 افتراضي في Railway للواجهات)
python3 -m http.server $PORT &

# 6. تشغيل وحش السرعة Hysteria2
echo "[+] Server is running on $HOST"
./hysteria server --config config.yaml
