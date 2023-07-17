FROM python:3.9

EXPOSE 8080

WORKDIR .
COPY requirements.txt .
COPY database/serviceAccountKey.json .
RUN pip install --no-cache-dir -r requirements.txt

CMD python app.py