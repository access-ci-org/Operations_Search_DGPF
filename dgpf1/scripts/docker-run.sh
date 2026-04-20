docker run --network=dgpf1_backend \
    -e GUNICORN_BIND=0.0.0.0:8000 \
    -e RUN_MIGRATIONS=true \
    -e RUN_COLLECTSTATIC=true \
    -v ${PWD}:/app \
    -p 80:8000 \
    -it operations-search-dgpf:latest