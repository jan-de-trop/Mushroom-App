REM Define some environment variables
SET IMAGE_NAME="mushroom-app-api-server"

REM Build the image based on the Dockerfile
docker build -t %IMAGE_NAME% -f Dockerfile .


REM Run the container
SET GCP_PROJECT="ai5-project"
SET GCP_ZONE="us-central1-a"
SET GOOGLE_APPLICATION_CREDENTIALS=/secrets/bucket-reader.json
cd ..
docker run  --rm --name %IMAGE_NAME% -ti ^
            --mount type=bind,source="%cd%\api-service",target=/app ^
            --mount type=bind,source="%cd%\persistent-folder",target=/persistent ^
            --mount type=bind,source="%cd%\secrets",target=/secrets ^
            -p 9000:9000 -e DEV=1 ^
            -e GOOGLE_APPLICATION_CREDENTIALS="%GOOGLE_APPLICATION_CREDENTIALS%" ^
            -e GCP_PROJECT="%GCP_PROJECT%" ^
            -e GCP_ZONE="%GCP_ZONE%" %IMAGE_NAME%