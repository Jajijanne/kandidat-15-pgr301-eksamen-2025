# PGR301 Eksamen 2025 - Besvarelse

Kandidatnummer: 15

---

### Oppgave 1 - Terraform, S3 og Infrastruktur som Kode
#### Leveranser

---

### Oppgave 2 Del 1
Jeg måtte legge til 

    Api:
        EndpointConfiguration: REGIONAL

under Globals i template.yaml da jeg fikk error om at det ikke var mulig å opprette flere API Gateway-EDGE endepunkter, og at grensen der var nådd.

#### Leveranser
- Her er url fra sam: https://mqh1pdmm9g.execute-api.eu-west-1.amazonaws.com/Prod/analyze/
- Her er s3 object: s3://kandidat-15-data/midlertidig/comprehend-20251120-215128-d54698db.json

### Oppgave 2 Del 2
#### Leveranser
- Workflow-fil: .github/workflows/sam-deploy.yml
- Successful deploy: https://github.com/Jajijanne/kandidat-15-pgr301-eksamen-2025/actions/runs/19553359377
- PR validation: https://github.com/Jajijanne/kandidat-15-pgr301-eksamen-2025/actions/runs/19553468113

For å kunne kjøre workflowen må du forke repositoriet. Deretter legge inn github secrets AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY. 

Hvis du vil deploye til aws trenger du bare å gjøre en endring på main og deretter pushe. Da vil workflowen kjøre sam validate, build og deploy.

Hvis du ikke vil deploye kan du lage en ny branch og gjøre endringer (kan være en liten kommentar et sted) der og deretter pushe til den branchen du nettopp lagde. Da vil kun sam validate og build kjøre.

---

### Oppgave 3 Del 1
#### Leveranse
Fungerende Dockerfil: sentiment-docker/Dockerfile

### Oppgave 3 Del 2
#### Leveranser
