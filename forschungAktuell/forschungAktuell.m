%[a, b, c]=urlread("http://podcast-mp3.dradio.de/podcast/2009/06/29/dlf_20090629_1635_2bf03d50.mp3");
%fid = fopen("a.mp3", "w")
%fwrite(fid, a);
%fclose(fid);

disp('Get links to broadcastings.');
url = "https://www.podcast.de/podcast/11600/archiv/?podcast/11600/archiv/=&seite=";
cnt = 1;
nrOfPages = 29;
clear links;
for n = 1:nrOfPages
    disp(['Parsing page ' num2str(n) ' of ' num2str(nrOfPages) ' pages.']);
    siteText = urlread([url num2str(n)]);
    siteLines = strsplit(siteText, "\n");
    for n = 1:numel(siteLines)
      line = siteLines{n};
      if strfind(line, "%2C+komplette+Sendung/\">Forschung aktuell ")
        range = strfind(line, "\"");
        links{cnt} = line(range(1)+1:range(2)-1);
        cnt++;
      end
    end
end

if exist("doneMp3", "file")
  load("doneMp3");
else
  doneMp3 = {};
end

disp('');
disp('Get link to mp3 of broadcasting and play.');
for n = numel(links):-1:1
  disp(['Parsing link ' num2str(n) ' of ' num2str(numel(links)) ' links.']);
  siteText = urlread(links{n});
  siteLines = strsplit(siteText, "\n");
  for n = 1:numel(siteLines)
    line = siteLines{n};
    if strfind(line, "<meta name=\"twitter:player:stream\" content=\"http://podcast-mp3.dradio.de/podcast/")
      range = strfind(line, "\"");
      mp3Link = line(range(3)+1:range(4)-1);
      
      if numel(cell2mat(strfind(doneMp3, mp3Link))) == 0
        disp('Downloading the mp3 file.')
        [audio, ~, ~]=urlread(mp3Link);
        fid = fopen("audio.mp3", "w");
        fwrite(fid, audio);
        fclose(fid);
        
        system("audio.mp3");
        
        input("Press enter for next.");
        
        doneMp3 = [doneMp3 mp3Link];
        save("doneMp3", "doneMp3");
      else
        disp('Broadcast already heard.')
      end
    end
  end    
end


