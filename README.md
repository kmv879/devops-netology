Домашнее задание 3.6

1. vagrant@vagrant:~$ telnet stackoverflow.com 80  
Trying 151.101.65.69...  
Connected to stackoverflow.com.  
Escape character is '^]'.  
GET /questions HTTP/1.0  
HOST: stackoverflow.com  

HTTP/1.1 301 Moved Permanently  
cache-control: no-cache, no-store, must-revalidate  
location: https://stackoverflow.com/questions  
x-request-guid: ed4b0b6e-1381-4f79-94e8-1137083dc511  
feature-policy: microphone 'none'; speaker 'none'  
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com  
Accept-Ranges: bytes  
Date: Thu, 30 Jun 2022 08:56:19 GMT  
Via: 1.1 varnish  
Connection: close  
X-Served-By: cache-fra19146-FRA  
X-Cache: MISS  
X-Cache-Hits: 0  
X-Timer: S1656579380.622243,VS0,VE94  
Vary: Fastly-SSL  
X- DNS-Prefetch-Control: off  
Set-Cookie: prov=9ba3b8ac-ad23-701e-dae7-ecb461dc8699; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly  

Connection closed by foreign host.  

Запрашивается страница /questions с сервера stackoverflow.com. В ответ сообщается о том что страница перемещена на постоянной основе по адресу https://stackoverflow.com/questions  


2. В браузере Chrome выполнен запрос http://stackoverflow.com/questions  

Request URL: http://stackoverflow.com/questions  
Request Method: GET  
Status Code: 301 Moved Permanently  
Remote Address: 151.101.1.69:80  
Referrer Policy: strict-origin-when-cross-origin  
Accept-Ranges: bytes  
cache-control: no-cache, no-store, must-revalidate  
Connection: keep-alive  
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com  
Date: Thu, 30 Jun 2022 09:16:39 GMT  
feature-policy: microphone 'none'; speaker 'none'  
location: https://stackoverflow.com/questions  
Set-Cookie: prov=a4461f54-ddc5-947d-64ee-5997d4bd4b14; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly  
Transfer-Encoding: chunked  
Vary: Fastly-SSL  
Via: 1.1 varnish  
X-Cache: MISS  
X-Cache-Hits: 0  
X-DNS-Prefetch-Control: off  
x-request-guid: 7c61ef36-1d8e-4550-a5be-789e86d8becb  
X-Served-By: cache-fra19156-FRA  
X-Timer: S1656580600.867873,VS0,VE94  
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9  
Accept-Encoding: gzip, deflate  
Accept-Language: ru-RU,ru;q=0.9  
Connection: keep-alive  
Host: stackoverflow.com  
Upgrade-Insecure-Requests: 1  
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36  

Запрос перенаправлен на https://stackoverflow.com/questions

Дольше всего обрабатывается запрос на открытие https://stackoverflow.com/questions 716ms

3. vagrant@vagrant:~$ dig +short myip.opendns.com @resolver1.opendns.com  
83.174.197.243  

4. vagrant@vagrant:~$ whois 83.174.197.243

address:        PJSC "Bashinformsvyaz"  
address:        Lenin street, 30  
address:        RUSSIA, 450000, Ufa city  
phone:          +7 3472 215999  
nic-hdl:        SSM18-RIPE  
created:        2004-11-22T07:45:45Z  
last-modified:  2016-09-15T09:49:23Z  
source:         RIPE # Filtered  
mnt-by:         RUMS-MNT  
mnt-by:         BASHNET-MNT  

% Information related to '83.174.192.0/20AS28812'  

route:          83.174.192.0/20  
descr:          RU, Ufa, JSC Bashinformsvyaz, RUMS  
origin:         AS28812  
mnt-by:         RUMS-MNT  
created:        2004-06-18T12:12:17Z  
last-modified:  2004-06-18T12:12:17Z  
source:         RIPE # Filtered  

Провайдер ПАО "Башинформсвязь", AS28812

5. vagrant@vagrant:~$ traceroute -IAn 8.8.8.8  
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets  
 1  10.0.2.2 [*]  0.094 ms  0.125 ms  0.115 ms  
 2  172.16.12.2 [*]  1.856 ms  2.015 ms  2.692 ms  
 3  172.16.15.1 [*]  0.928 ms  0.945 ms  1.591 ms  
 4  83.174.197.241 [AS28812]  1.718 ms  1.737 ms  1.783 ms  
 5  83.174.194.97 [AS28812]  2.333 ms  2.443 ms  2.436 ms  
 6  83.174.195.62 [AS28812]  3.047 ms  2.136 ms  2.381 ms  
 7  95.167.125.18 [AS12389]  2.867 ms  3.115 ms  5.479 ms  
 8  * * *  
 9  72.14.197.6 [AS15169]  29.146 ms  29.247 ms  29.152 ms  
10  108.170.250.129 [AS15169]  29.656 ms  29.889 ms  30.048 ms  
11  108.170.250.130 [AS15169]  29.094 ms  29.303 ms  20.863 ms  
12  142.250.238.214 [AS15169]  38.260 ms  38.284 ms  39.298 ms  
13  142.250.233.0 [AS15169]  35.962 ms  36.103 ms  36.582 ms  
14  172.253.51.221 [AS15169]  37.321 ms  38.259 ms  39.072 ms  
15  * * *  
16  * * *  
17  * * *  
18  * * *  
19  * * *  
20  * * *  
21  * * *  
22  * * *  
23  * * *  
24  8.8.8.8 [AS15169]  35.471 ms  36.052 ms  36.120 ms  


6. vagrant@vagrant:~$ mtr  -n 8.8.8.8  

 My traceroute  [v0.95]  
vagrant (10.0.2.15) -> 8.8.8.8 (8.8.8.8)                                                                    2022-06-30T11:58:32+0000  
Keys:  Help   Display mode   Restart statistics   Order of fields   quit  
                                                                                            Packets               Pings  
 Host                                                                                     Loss%   Snt   Last   Avg  Best  Wrst StDev  
 1. 10.0.2.2                                                                               0.0%    85    0.4   0.4   0.1   6.2   0.6  
 2. 172.16.12.2                                                                            0.0%    85    1.8   2.0   1.4   7.8   0.7  
    172.16.15.1  
 3. 172.16.15.1                                                                            0.0%    85    2.6   2.0   1.4   5.9   0.6  
    83.174.197.241  
 4. 83.174.197.241                                                                         0.0%    85    2.0   2.7   1.4  15.6   2.1  
    83.174.194.97  
 5. 83.174.194.97                                                                          0.0%    85    1.7   3.0   1.5  16.0   2.1  
    83.174.195.62  
 6. 83.174.195.62                                                                          0.0%    85    2.7   3.9   2.2  14.6   2.1  
    95.167.125.18  
 7. 95.167.125.18                                                                          0.0%    85    3.4   7.1   1.8  73.1  11.0  
    185.140.148.153  
 8. 185.140.148.153                                                                       48.8%    85   20.3  21.8  20.0  36.7   2.7  
    72.14.197.6  
 9. 72.14.197.6                                                                            1.2%    85   22.5  22.4  20.8  37.2   2.4  
    108.170.250.129  
10. 108.170.250.129                                                                        0.0%    85   21.8  23.0  20.6  34.9   2.4  
    108.170.250.130  
11. 108.170.250.130                                                                        0.0%    85   21.2  22.9  20.8  42.9   4.6  
    142.250.238.214  
12. 142.250.238.214                                                                        0.0%    85   38.3  42.7  35.2  89.4  10.3  
    142.250.233.0  
13. 142.250.233.0                                                                          2.4%    85   42.5  38.2  34.5  58.7   4.9  
    172.253.51.221  
14. 172.253.51.221                                                                         4.8%    85   37.0  38.9  36.4  65.7   4.2  
15. (waiting for reply)  
16. (waiting for reply)  
17. (waiting for reply)  
18. (waiting for reply)  
19. (waiting for reply)  
20. (waiting for reply)  
21. (waiting for reply)  
22. (waiting for reply)  
23. 8.8.8.8                                                                               94.0%    84   38.2  38.7  37.1  40.0   1.1  

Самая большая задержка на 12 участке

7. vagrant@vagrant:~$ dig +short NS dns.google  
ns1.zdns.google.  
ns2.zdns.google.  
ns3.zdns.google.  
ns4.zdns.google.  

За dns.google отвечают DNS сервера ns1.zdns.google, ns2.zdns.google, ns3.zdns.google, ns4.zdns.google

vagrant@vagrant:~$ dig +short dns.google  
8.8.4.4  
8.8.8.8  

dns.google имеет А записи 8.8.4.4 и 8.8.8.8  

8. vagrant@vagrant:~$ dig +short -x 8.8.8.8  
dns.google.  


