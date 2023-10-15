#!/bin/bash

# for detail steps:
# https://stackoverflow.com/questions/21297139/how-do-you-sign-a-certificate-signing-request-with-your-certification-authority

CERT_DIR="credentials/certs"

if [[ ! -d "$CERT_DIR/root-ca" ]]; then
  echo "$CERT_DIR/root-ca doesn't exist. prepare your root ca to generate intermediate certs"
  exit 1
fi


intermediate_key="$CERT_DIR/intermediate/key.pem"
intermediate_cert="$CERT_DIR/intermediate/cert.pem"
intermediate_csr="$CERT_DIR/intermediate/cert.csr"

if [[ ! -d "$CERT_DIR/intermediate" ]]; then
  mkdir -p "$CERT_DIR/intermediate"

  echo "generating private key for intermediate cert"
  openssl req \
      -new \
      -newkey rsa:4096 \
      -days 365 \
      -nodes \
      -sha256 \
      -subj "/C=CA/ST=Toronto/L=Springfield/O=Nandi/CN=nandi.sh" \
      -keyout $intermediate_key \
      -out $intermediate_csr
  touch "$CERT_DIR/intermediate/index.txt"
  echo '01' > "$CERT_DIR/intermediate/serial.txt"

  # verify CSR
  openssl req -text -noout -verify -in "$intermediate_csr"

cat << EOF > "$CERT_DIR/intermediate/openssl.cnf"


####################################################################
[ ca ]
default_ca    = CA_default      # The default ca section

[ CA_default ]

default_days     = 365          # How long to certify for
default_crl_days = 30           # How long before next CRL
default_md       = sha256       # Use public key default MD
preserve         = no           # Keep passed DN ordering

x509_extensions = ca_extensions # The extensions to add to the cert

email_in_dn     = no            # Don't concat the email in the DN
copy_extensions = copy          # Required to copy SANs from CSR to cert

base_dir      = $CERT_DIR
certificate   = $CERT_DIR/root-ca/cert.pem   # The CA certifcate
private_key   = $CERT_DIR/root-ca/key.pem    # The CA private key
new_certs_dir = $CERT_DIR/intermediate              # Location for new certs after signing
database      = $CERT_DIR/intermediate/index.txt    # Database index file
serial        = $CERT_DIR/intermediate/serial.txt   # The current serial number

unique_subject = no  # Set to 'no' to allow creation of
                     # several certificates with same subject.

####################################################################
[ req ]
default_bits       = 4096
default_keyfile    = cakey.pem
distinguished_name = ca_distinguished_name
x509_extensions    = ca_extensions
string_mask        = utf8only

####################################################################
[ ca_distinguished_name ]
countryName         = Country Name (2 letter code)
countryName_default = CA

stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = Ontario

localityName                = Locality Name (eg, city)
localityName_default        = Newmarket

organizationName            = Organization Name (eg, company)
organizationName_default    = Nandiheath

organizationalUnitName         = Organizational Unit (eg, division)
organizationalUnitName_default = Server Research Department

commonName         = Common Name (e.g. server FQDN or YOUR name)
commonName_default = Cloudflare CA

emailAddress         = Email Address
emailAddress_default = me@nandi.sh

####################################################################
[ ca_extensions ]

subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always, issuer
basicConstraints       = critical, CA:true
keyUsage               = keyCertSign, cRLSign

####################################################################
[ signing_policy ]
countryName            = optional
stateOrProvinceName    = optional
localityName           = optional
organizationName       = optional
organizationalUnitName = optional
commonName             = supplied
emailAddress           = optional

####################################################################
[ signing_req ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, keyEncipherment

EOF
  openssl ca -create_serial -config "$CERT_DIR/intermediate/openssl.cnf" -policy signing_policy -extensions signing_req -cert "$CERT_DIR/root-ca/cert.pem" -keyfile "$CERT_DIR/root-ca/key.pem" -in "$intermediate_csr" -notext -out "$intermediate_cert"

  # verify the cert
  openssl x509 -purpose -in "$intermediate_cert" -text -noout
else
  echo "$CERT_DIR/intermediate already exists. abort generating "
fi

if [[ ! -d "$CERT_DIR/k3s" ]]; then
  echo "+++ Generate certs for k3s ..."

  mkdir -p "$CERT_DIR/k3s"

  cp "$CERT_DIR/root-ca/cert.pem" "$intermediate_key" "$intermediate_cert" "$CERT_DIR/k3s"

  curl -sL https://github.com/k3s-io/k3s/raw/master/contrib/util/generate-custom-ca-certs.sh | DATA_DIR="$CERT_DIR/k3s" bash -
  rm -rf /var/lib/rancher
else
  echo "$CERT_DIR/k3s already exists. abort generating "
fi







