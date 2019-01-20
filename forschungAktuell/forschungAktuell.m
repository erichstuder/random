disp('Get links to broadcastings.');
url = "https://www.podcast.de/podcast/11600/archiv/?podcast/11600/archiv/=&seite=";

% find nrOfPages
lastPageFindPattern = '" title="Zur letzten Seite">Seite ';
lastPageFindPatternLength = numel(currentPageFindPattern);
siteText = urlread([url "1"]);
startPos = strfind(siteText, lastPageFindPattern)+lastPageFindPatternLength+2;
endPos = startPos + strfind(siteText(startPos:end), '<')-2;
nrOfPages = str2num(siteText(startPos:endPos(1)));

cnt = 1;
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

for n = numel(links):-1:1
	disp('');
	disp(['Parsing broadcast link ' num2str(n) ' of ' num2str(numel(links)) ' links.']);
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
				answer = input("Mark as heard? [y/n]: ", 's');
				if tolower(answer) == 'y'
					doneMp3 = [doneMp3 mp3Link];
					save("doneMp3", "doneMp3");
					disp('Marked as heard.');
				end
				input("Press enter to play next");
			else
				disp('Broadcast already heard.');
			end
		end
	end    
end

disp('');
disp('*****');
disp('YOU HAVE HEARD ALL THE BROADCASTS!!!'); %this will never happen :-D
disp('*****');