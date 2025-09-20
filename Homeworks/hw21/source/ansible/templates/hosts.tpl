[nginx_hosts]
%{ for ip in ips ~}
${ip}
%{ endfor ~}

