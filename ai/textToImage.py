import sys
from PIL import Image, ImageDraw, ImageFont  # install Pillow to use PIL


def getArialFontPath():
    if sys.platform.startswith('win'):
        return 'arial.ttf'
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        return '/usr/share/fonts/truetype/Arial.ttf'
    else:
        raise EnvironmentError('Unsupported platform')


def textToImage(text):
    fontSize = 20
    fontPath = getArialFontPath()
    img = Image.new('RGB', (100, 40), color=(255, 255, 255))
    fnt = ImageFont.truetype(fontPath, fontSize)
    d = ImageDraw.Draw(img)
    d.text((10, 5), text, font=fnt, fill=(0, 0, 0))
    return img


def createImageText(hour_, minute_):
    hourString = str(hour_)
    minuteString = str(minute_)
    return hourString.rjust(4, ' ') + ':' + minuteString.zfill(2)


def createImageName(hour_, minute_):
    hourString = str(hour_)
    minuteString = str(minute_)
    return hourString.zfill(2) + '_' + minuteString.zfill(2)


for hour in range(0, 23+1):
    for minute in range(0, 59+1):
        imageText = createImageText(hour, minute)
        imageName = createImageName(hour, minute)
        image = textToImage(imageText)
        image.save('images/' + imageName + '.png')
