clc;
clear;

readerobj = setupSystemObjects();
cars = initializeTracks(); 
ID = 1; 
while ~isDone(readerobj.reader)

        frame = readerobj.reader.step();
        mask = readerobj.detector.step(frame);
        mask = bwmorph(mask,'clean');
        mask = bwmorph(mask,'majority');
        mask = bwmorph(mask,'open');
        [area, centroids, rec] = readerobj.blobAnalyser.step(mask);
        for i = 1:length(cars)
            rect = cars(i).bbox;
            predictedCentroid = predict(cars(i).kalmanFilter);
            predictedCentroid = int32(predictedCentroid) - rect(3:4) / 2;
            cars(i).bbox = [predictedCentroid, rect(3:4)];
        end
        tr_n = length(cars);
        obj = size(centroids, 1);
        cost = zeros(tr_n, obj);
        for i = 1:tr_n
            cost(i, :) = distance(cars(i).kalmanFilter, centroids);
        end
        Distanc = 20;
        [TR, inviTR, dete]=assignDetectionsToTracks(cost, Distanc);  
        numAssignedTracks = size(TR, 1);
        for i = 1:numAssignedTracks
            trackIdx = TR(i, 1);
            detectionIdx = TR(i, 2);
            centroid = centroids(detectionIdx, :);
            rect = rec(detectionIdx, :);
            correct(cars(trackIdx).kalmanFilter, centroid);
            cars(trackIdx).bbox = rect;
            cars(trackIdx).age = cars(trackIdx).age + 1;
            cars(trackIdx).totalVisibleCount = cars(trackIdx).totalVisibleCount + 1;
            cars(trackIdx).consecutiveInvisibleCount = 0;
        end
                
     for i = 1:length(inviTR)
            ind = inviTR(i);
            cars(ind).age = cars(ind).age + 1;
            cars(ind).consecutiveInvisibleCount = cars(ind).consecutiveInvisibleCount + 1;
     end    
        cars=deleteLostTracks(cars);
        centroids = centroids(dete, :);
        rec = rec(dete, :);
        for i = 1:size(centroids, 1)
            centroid = centroids(i,:);
            rect = rec(i, :);
            kalmanFilter = configureKalmanFilter('ConstantVelocity',centroid, [200, 50], [100, 25], 100);
            newTrack = struct('id', ID,'bbox', rect, 'kalmanFilter', kalmanFilter, 'age', 1, 'totalVisibleCount', 1, 'consecutiveInvisibleCount', 0);
            cars(end + 1) = newTrack;
            ID = ID + 1;
        end
       frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        if ~isempty(cars)
            reliableTrackInds =[cars(:).totalVisibleCount] > 10;
            reliableTracks = cars(reliableTrackInds);

            if ~isempty(reliableTracks)
                rec = cat(1, reliableTracks.bbox);
                ids = int32([reliableTracks(:).id]);
                lb = cellstr(int2str(ids'));
                predictedTrackInds=[reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(lb));
                isPredicted(predictedTrackInds) = {' predicted'};
                lb = strcat(lb, isPredicted);

                frame = insertObjectAnnotation(frame, 'rectangle',rec, lb,'color','blue','TextColor','white');
            end
        end
        readerobj.videoPlayer.step(frame);

end
