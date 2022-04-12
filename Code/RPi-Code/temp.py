qr.add_data('https://medium.com/@ngwaifoong92')
qr.make(fit=True)
img = qr.make_image(fill_color="black", back_color="white").convert('RGB')
