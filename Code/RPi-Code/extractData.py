import cv2
import numpy as np
import matplotlib.pyplot as plt
from skimage import io
import pytesseract
from pytesseract import Output
import urllib.request
from pdf2image import convert_from_path

# downloading the pdf
pdfPath = ""
url = "http://info.tm.edu.ro:8088/~malbu/eBon/PDFs/S-C-MEGA-IMAGE-SRL_04-12-2021_0M5K9K.pdf"
def downloadPDF(url, filename):
    response = urllib.request.urlopen(url)
    file = open(filename + ".pdf", 'wb')
    file.write(response.read())
    file.close()
downloadPDF(url, "test")
pages = convert_from_path("test.pdf", 500)
i = 0
for page in pages:
    page.save(f"pages/out{i}.jpg", "JPEG")
    i += 1

# preparing the images for the procces
images = []
for i in range(len(pages)):
    page = cv2.imread(f"out{i}.jpg")
    ret, thresh = cv2.threshold(page, 210, 255, cv2.THRESH_BINARY)
    images.append(thresh)

for i in range(len(pages)):
    cv2.imshow(thresh, f"thresh{i}")

# process the images
"""
for i in range(len(pages)):

    data = pytesseract.image_to_data(images[i], output_type = Output.DICT)
    nBoxes = len(data["level"])
    for i in range(nBoxes):
        (x, y, w, h) = (data['left'][i], data['top'][i], data['width'][i], data['height'][i])
        images[i] = cv2.rectangle(images[i], (x, y), (x + w,  y + h), (0, 0, 255), 2)

    extracted_text = pytesseract.image_to_string(images[i], lang = 'ron')
    print(extracted_text)
"""