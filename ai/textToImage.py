import sys
from PIL import Image, ImageDraw, ImageFont #install Pillow to use PIL

img = Image.new('RGB', (1000, 300), color=(255, 255, 255))

if sys.platform.startswith('win'):
    pass
elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
    fnt = ImageFont.truetype('/usr/share/fonts/truetype/Arial.ttf', 30)
else:
    raise EnvironmentError('Unsupported platform')

d = ImageDraw.Draw(img)
d.text((10, 100), "Hello World", font=fnt, fill=(0, 0, 0))

img.save('pil_text.png')
