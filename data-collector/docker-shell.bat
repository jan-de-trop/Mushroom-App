REM Define some environment variables
SET IMAGE_NAME="mushroom-app-data-collector"

REM Build the image based on the Dockerfile
docker build -t %IMAGE_NAME% -f Dockerfile .

REM Create the network if we don't have it yet
docker network inspect mushroomappnetwork >NUL || docker network create mushroomappnetwork

REM Run the container
SET GCP_PROJECT="ai5-project"
SET GCP_ZONE="us-central1-a"
SET GOOGLE_APPLICATION_CREDENTIALS=/secrets/bucket-reader.json
cd ..
docker run  --rm --name %IMAGE_NAME% -ti ^
            --mount type=bind,source="%cd%\data-collector",target=/app ^
            --mount type=bind,source="%cd%\persistent-folder",target=/persistent ^
            --mount type=bind,source="%cd%\secrets",target=/secrets ^
            -e GOOGLE_APPLICATION_CREDENTIALS="%GOOGLE_APPLICATION_CREDENTIALS%" ^
            -e GCP_PROJECT="%GCP_PROJECT%" ^
            -e GCP_ZONE="%GCP_ZONE%" ^
            -e DATABASE_URL=postgres://mushroomapp:awesome@mushroomappdb-server:5432/mushroomappdb ^
            -- network mushroomappnetwork %IMAGE_NAME%
