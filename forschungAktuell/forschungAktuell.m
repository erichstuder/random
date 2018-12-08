%[a, b, c]=urlread("http://podcast-mp3.dradio.de/podcast/2009/06/29/dlf_20090629_1635_2bf03d50.mp3");
%fid = fopen("a.mp3", "w")
%fwrite(fid, a);
%fclose(fid);

url = "https://www.podcast.de/podcast/11600/archiv/?podcast/11600/archiv/=&seite=";
cnt = 1;
clear links;
for n = 1:29
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

cnt = 1;
clear mp3Links;
for n = 1:numel(links)
  siteText = urlread(links{n});
  siteLines = strsplit(siteText, "\n");
  for n = 1:numel(siteLines)
    line = siteLines{n};
    if strfind(line, "<meta name=\"twitter:player:stream\" content=\"http://podcast-mp3.dradio.de/podcast/")
      range = strfind(line, "\"");
      mp3Links{cnt} = line(range(3)+1:range(4)-1);
      cnt++;
    end
  end    
end

if exist("doneMp3", "file")
  load("doneMp3");
else
  doneMp3 = {};
end

for n = numel(mp3Links):-1:1
  n
  if numel(cell2mat(strfind(doneMp3, mp3Links(n)))) == 0
    [audio, ~, ~]=urlread(mp3Links{n});
    fid = fopen("audio.mp3", "w");
    fwrite(fid, audio);
    fclose(fid);
    
    system("audio.mp3");
    
    input("press enter for next");
    
    doneMp3 = [doneMp3 mp3Links(n)];
    save("doneMp3", "doneMp3");
  end
end


