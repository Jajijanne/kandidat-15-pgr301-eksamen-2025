# PGR301 Eksamen 2025 - Besvarelse

Kandidatnummer: 15

---

### Oppgave 1 - Terraform, S3 og Infrastruktur som Kode
#### Leveranser


### Oppgave 2 Del 1
Jeg måtte legge til 

    Api:
        EndpointConfiguration: REGIONAL

under Globals i template.yaml da jeg fikk error om at det ikke var mulig å opprette flere API Gateway-EDGE endepunkter, og at grensen der var nådd.
- Her er url fra sam: https://mqh1pdmm9g.execute-api.eu-west-1.amazonaws.com/Prod/analyze/
- Her er s3 object: s3://kandidat-15-data/midlertidig/comprehend-20251120-215128-d54698db.json
