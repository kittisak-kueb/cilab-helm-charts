{{- define "cilab.webCfg" -}}
nginx-conf.conf: |
  server {
    listen 80;
    listen [::]:80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html index.htm;
    client_max_body_size 0;
    large_client_header_buffers 4 32k;

    location / {
      try_files $uri $uri/ /index.html;
    }

    location ~ ^/api {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-URL $request_uri;     
      rewrite ^/api(.*) $1 break;
      proxy_pass http://127.0.0.1:8080;
      proxy_buffer_size          128k;
      proxy_buffers              4 256k;
      proxy_busy_buffers_size    256k;
    }

    location ~ ^/socket.io {
      proxy_set_header Upgrade $http_upgrade;
      proxy_http_version 1.1;
      proxy_set_header X-Forwarded-Host $http_host;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header Host $host;
      proxy_set_header Connection "upgrade";
      proxy_cache_bypass $http_upgrade;
      rewrite ^/socket.io(.*) /socket.io/$1 break;
      proxy_pass http://127.0.0.1:3001;
      proxy_buffer_size          128k;
      proxy_buffers              4 256k;
      proxy_busy_buffers_size    256k;
    }

    location ~ ^/static/ {
      access_log off;
    }

    location /healthz {
      add_header Content-Type text/plain;
      access_log off;
      return 200 "healthy\n";
    }

    location ~ /\.ht {
      deny all;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
      root /usr/share/nginx/html;
    }
  }
{{- end -}}