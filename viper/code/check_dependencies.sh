# set -x
items=( \
androguard \
appdirs \
asn1crypto \
beautifulsoup4 \
bitstring \
cached-property \
cffi \
cryptography \
Django \
django-bootstrap-form \
django-crispy-forms \
django-extensions \
django-favicon \
django-filter \
django-rest-swagger \
django-sslserver \
django-url-filter \
djangorestframework \
djangorestframework-queryfields \
dnspython \
drf-nested-routers \
enum34 \
fileobjects \
future \
idna \
ipaddress \
itypes \
jbxapi \
Jinja2 \
jsonschema \
mccabe \
MarkupSafe \
olefile \
oletools \
openapi-codec \
packaging \
pbkdf2 \
pefile \
pyOpenSSL \
pyasn1 \
pyclamd \
pycodestyle \
pycparser \
pycrypto \
pydeep \
pyelftools \
pylzma \
pymisp \
pyparsing \
pypdns \
pypssl \
python-dateutil \
python-magic \
pytz \
PyMISPGalaxies \
PyTaxonomies \
r2pipe \
rarfile \
requests \
requests-cache \
scandir \
simplejson \
six \
socks \
SQLAlchemy \
ScrapySplashWrapper \
terminaltables \
verify-sigs \
virustotal \
virustotal-api \
whitenoise \
xxxswf \
yara-python \
yara \
)

items=( \
        appdirs \
        cached-property \
        enum34 \
        Jinja2 \
        MarkupSafe \
        mccabe \
        pycodestyle \
        simplejson \
)

for pkg in "${items[@]}"; do
    echo "\n\n===== $pkg =====\n"
    pip3 show "${pkg}" | grep Requires | cut -d ":" -f 2 | tr "," "\n"
    find . -name "*.py" |xargs -I % grep -Hi "${pkg}" % | grep import | cut -d " " -f 1 | sort | uniq
done
