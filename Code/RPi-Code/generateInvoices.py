from borb.pdf.document import Document
from borb.pdf.page.page import Page

from borb.pdf.canvas.layout.page_layout.multi_column_layout import SingleColumnLayout
from borb.pdf.canvas.layout.image.image import Image

from borb.pdf.canvas.layout.table.fixed_column_width_table import FixedColumnWidthTable as Table
from borb.pdf.canvas.layout.text.paragraph import Paragraph
from borb.pdf.canvas.layout.layout_element import Alignment
from datetime import datetime
import random

from borb.pdf.pdf import PDF
from borb.pdf.canvas.color.color import HexColor, X11Color
from borb.pdf.page.page import DestinationType

from borb.pdf.canvas.layout.table.fixed_column_width_table import FixedColumnWidthTable
from borb.pdf.canvas.layout.table.table import TableCell

from decimal import Decimal
import json

import invoicesFunctions as functions

# creating the document
pdf = Document()

# adding a page
page = Page()
pdf.append_page(page)

pageLayout = SingleColumnLayout(page)
pageLayout.vertical_margin = page.get_page_info().get_height() * Decimal(0.02)

# creating the invoices variables
products = []
now = datetime.now()

# adding a product to the invoice list
products.append(("MASINA DE SPALAT CALGON 13000RPM NOU NOUTA ADUSA DIN GERMANIA", 2, 34))
products.append(("DISCOUNT", 3, 4))
products.append(("KETCHUP", 1, 5))
products.append(("MAHONEZ", 1, 5))


page_layout = SingleColumnLayout(page)
page_layout.vertical_margin = page.get_page_info().get_height() * Decimal(0.02)

# adding the eBon / company logo
page_layout.add(
    Image(
        "https://s3.stackabuse.com/media/articles/creating-an-invoice-in-python-with-ptext-1.png",
        width=Decimal(100),
        height=Decimal(100),
    ))

page_layout.add(Paragraph("[Company Name]", font="Courier-bold", horizontal_alignment=Alignment.CENTERED))
page_layout.add(Paragraph("[Street Address]", font="Courier-bold", horizontal_alignment=Alignment.CENTERED))
page_layout.add(Paragraph("[Phone]", font="Courier-bold", horizontal_alignment=Alignment.CENTERED))
page_layout.add(Paragraph(f"{now.day}/{now.month}/{now.year} {datetime.now().strftime('%H:%M:%S')}", font="Courier-bold", horizontal_alignment=Alignment.CENTERED))
page_layout.add(Paragraph(f"# {str(functions.generateRandomReceiptNumber())}", font="Courier-bold", horizontal_alignment=Alignment.CENTERED))


# Invoice information table
# page_layout.add(functions.buildInvoiceInformation())

# itemized description
page_layout.add(functions.buildItemizedDescriptionTable(products))

# outline
# pdf.add_outline("Your Invoice", 0, DestinationType.FIT, page_nr=0)

with open("output.pdf", "wb") as pdfFileHandle:
	PDF.dumps(pdfFileHandle, pdf)

