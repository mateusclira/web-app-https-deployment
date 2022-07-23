rm *.pem

openssl req -x509 -newkey  rsa:4096 -days 180 -keyout ca-key.pem -out ca-cert.pem -subj "/C=BR/ST=PE/L=Recife/O=Schub/CN=*/emailAdress=mateusc.lira@gmail.com"

echo "CA's self-signed certificate"

openssl x509 -in ca-cert.pem -noout -text