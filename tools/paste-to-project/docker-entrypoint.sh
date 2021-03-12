#!/bin/bash

ownership() {
    # Fixes ownership of output files
    # source: https://github.com/BD2KGenomics/cgl-docker-lib/blob/master/mutect/runtime/wrapper.sh#L5
    user_id=$(stat -c '%u:%g' /app)
    chown -R ${user_id} /app
}
echo "Waiting for postgress"
chmod +x wait-for-it.sh
./wait-for-it.sh -t ${WAIT_FOR_DB} ${DB_SERVICE}:${DB_PORT} || exit 1
echo ''
echo '--------------------------'
echo 'Database migration'
echo '--------------------------'
echo ''
python manage.py makemigrations || exit 1
python manage.py migrate || exit 1
echo ''
echo '--------------------------'
echo 'Fixing ownership of files'
echo '--------------------------'
echo ''
ownership
echo ''
echo '--------------------------'
echo 'Collectstatics'
echo '--------------------------'
echo ''
python manage.py collectstatic --noinput || exit 1
echo ''
echo '--------------------------'
echo 'Create superuser'
echo '--------------------------'
echo ''
python manage.py shell << EOF
from django.contrib.auth.models import User

if not User.objects.filter(username='$SUPER_NAME').exists():
    print('Creating superuser: $SUPER_NAME')
    User.objects.create_superuser('$SUPER_NAME', '$SUPER_MAIL', '$SUPER_PASSWORD')
else:
    print('User: $SUPER_NAME already created')
EOF
echo ''
echo '--------------------------'
echo 'Run server at: '$HOST_NAME':2000'
echo '--------------------------'
echo ''
if [ "$PUBLIC" ==  0 ]; then
    python manage.py runserver 0.0.0.0:2000
else
    gunicorn --bind 0.0.0.0:2000 djangoplateapp.wsgi
fi
