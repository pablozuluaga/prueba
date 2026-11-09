# Genera fondos desenfocados y teñidos para rellenar el formato vertical 9:16
from PIL import Image, ImageFilter, ImageEnhance
import glob, os
os.makedirs("fotos/blur", exist_ok=True)
for p in glob.glob("fotos/*.jpg"):
    im = Image.open(p).convert("RGB")
    W, H = 540, 960
    s = max(W / im.width, H / im.height)
    im = im.resize((int(im.width * s) + 1, int(im.height * s) + 1), Image.LANCZOS)
    l, t = (im.width - W) // 2, (im.height - H) // 2
    im = im.crop((l, t, l + W, t + H)).filter(ImageFilter.GaussianBlur(28))
    im = ImageEnhance.Color(im).enhance(1.2)
    im.save("fotos/blur/" + os.path.basename(p), quality=90)
