// The tokens in this file are from the 'concourse-build-pipelines'
// ServiceAccount and they are managed in the environments repository.

clusters = [
  {
    name    = "test-2.k8s.cloud-platform.dsd.io"
    host    = "https://api.test-2.k8s.cloud-platform.dsd.io"
    token   = "eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJjb25jb3Vyc2UiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiY29uY291cnNlLXdlYi10b2tlbi1oZzQ5bSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJjb25jb3Vyc2Utd2ViIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiZmYyZGQxMTItYzU3Yi0xMWU4LWI1OTItMGFiOTM1NTYxM2QwIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmNvbmNvdXJzZTpjb25jb3Vyc2Utd2ViIn0.tXX77crXjPPJAS2enw1HrOzzjhbWOKlsNxB0hIpsTqw1gw26eUoSDMRMuFXmaZGoaWs7FwTzunp6yM5oeZyvh5Tfi-RP2sGUwvRbqSId27J9VVMe0yR2lAh8sQYh081WkwoDL7NHoKXuRZ6piRBaQOKO9YIFG93HoNjxVfwMM0GJ8SQ2wFU9Ay0Pqf58LZ8TRrPORccVb9hkRrv_nr0H48FQ9R2r27d0RnSuoUykJ3B9jr90izUmQ-rxDp0xEtTqtr6KaSmj2QpVnkb0CRBkIB2OE7sQceZS3YBp73CELIJzVetFB-kdhl-tmp3MmQwrVUl3q3dKJ7RrdR2Zbt4DcA"
    ca_data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMwekNDQWJ1Z0F3SUJBZ0lNRlZmMVNtNURtM3NQa2V4bE1BMEdDU3FHU0liM0RRRUJDd1VBTUJVeEV6QVIKQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13SGhjTk1UZ3dPVEkwTVRNeE1UTTNXaGNOTWpnd09USXpNVE14TVRNMwpXakFWTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQTBrYXo0ZEIwWmozTzBubjN2MXVZdDJ6aktGVjJYWG1EVFBTdzhmTUpCOXZMblI2NU5NM0kKVE1vL0VsRXdBQmkzT3JJMmtGdzNZWXB0VW55VkVuSWNNeXE4U3U4YzhYQXRSeXpvMi9PYTZVQVAwQnJjS3F2QgpTUWdJc00xRUc2SkZHUk5DU0NSZDBGSW45RWRaa1BiTkNDdnNBU0s3VkMwczFiUi90clZMY1RrUlU4QVp0RC9FCmtmMFZHWVpXQk5kYlhKQlR3R0IzUnFrSW0zNWl3bzZvdVFvbmVXaDVDVHJyNzNFMkdWRDlhNXB0NWJtdmVCWmkKTDRVVEVZeDVFeFVtSXF0SkwvSDRWOTZzYWs0RzBtRTJlMTRGQWJHUmF3R3VFZ21lSWNSTXdYNG53NnluU3JVdwo5Nk82QmlmMDdvS0I4QTRPbVAxSWExVWk5UWZYMUF0TnlRSURBUUFCb3lNd0lUQU9CZ05WSFE4QkFmOEVCQU1DCkFRWXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFqeFFCMzUzWlRGVVMKZVo4MngxM3FTRlAxUm1CeGxQRG9FL2FNNjk4VktBTEI2QlFyUEE3Yk80NHNORERReWVrRU9uY05ZNi8zdEt1MQp1KzFTNjZ3WjgvZnk5SVhiYlJ2aUQ1ampKK1FkQkJiSEl0ZyttQk5MMHlKemVGRDFVZVB0UytsUS95S0lZdUxhCkJFQnJBaGlTQW5YdlNWS2QrZWJzNVdENllVUzBJL08xcEdDRjJiTE5zREFYMHhhUVRNdVRNaGZUVnMrSThGTzEKWnlqenhKNlllVEU4TlNoR00rcHdYWnhwRE1ubUJsMkl5VjgyVGc3ODdzT3MwaVE1QTVhYktVdGlDTnNTZWR6OQowaGxIQ1BJRDJYYXhoNEx4SzJoakZYUzc1WXVjOU41Vlh2Z1VJNmt1a2RicDdoL1doc0R3NENFdEhXeFdUZGF3CnpEWjJReENLUWc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
  },
]
