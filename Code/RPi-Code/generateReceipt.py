from borb.pdf.document import Document
from borb.pdf.page.padge import Page

from borb.pdf.canvas.layout.page_layout.multi_column_layout import SingleColumnLayout
from borb.pdf.canvas.layout.image.image import Image

from borb.pdf.canvas.layout.table.fixed_column_width_table import FixedColumnWidthTable as Table
from borb.pdf.canvas.layout.text.paragraph import Paragraph
from borb.pdf.canvas.layout.layout_element import Alignment
from datetime import datetime
import random

from borb.pdf.pdf import PDF

from decimal import Decimal

# creating the document
pdf = Document()

# adding a page
page = Page()
pd.append_page(page)

pageLayout = SingleColumnLayout(page)
pageLayout.vertical_margin = page.get_page_info().get_height() * Decimal(0.02)

# adding the eBon / shop logo
pageLayout.add(Image("", width = Decimal(128), height = Decimal(128)))


def buildInvoiceInformation():
	table001 = Table(number_of_rows = 5, number_of_columns = 3)

	table_001.add(Paragraph("[Street Address]"))
    	table_001.add(Paragraph("Date", font="Helvetica-Bold", horizontal_alignment=Alignment.RIGHT))    
    	now = datetime.now()
    	table_001.add(Paragraph("%d/%d/%d" % (now.day, now.month, now.year)))

    	table_001.add(Paragraph("[City, State, ZIP Code]"))
    	table_001.add(Paragraph("Invoice #", font="Helvetica-Bold", horizontal_alignment=Alignment.RIGHT))
    	table_001.add(Paragraph("%d" % random.randint(1000, 10000))

    	table_001.add(Paragraph("[Phone]"))
    	table_001.add(Paragraph("Due Date", font="Helvetica-Bold", horizontal_alignment=Alignment.RIGHT))
    	table_001.add(Paragraph("%d/%d/%d" % (now.day, now.month, now.year)))

    	table_001.add(Paragraph("[Email Address]"))
    	table_001.add(Paragraph(" "))
    	table_001.add(Paragraph(" "))

    	table_001.add(Paragraph("[Company Website]"))
    	table_001.add(Paragraph(" "))
    	table_001.add(Paragraph(" "))

    	table_001.set_padding_on_all_cells(Decimal(2), Decimal(2), Decimal(2), Decimal(2))
    	table_001.no_borders()

	return table_001

page_layout = SingleColumnLayout(page)
page_layout.vertical_margin = page.get_page_info().get_height() * Decimal(0.02)
page_layout.add(
	Image(
		"https://s3.stackabuse.com/media/articles/creating-an-invoice-in-python-with-ptext-1.png",        
        	width = Decimal(128),
        	height = Decimal(128),
        ))

# Invoice information table
page_layout.add(_build_invoice_information())

# Empty paragraph for spacing
page_layout.add(Paragraph(" "))

with open("output.pdf", "wb") as pdfFileHandle:
	pdf.dumps(pdfFileHandle, pdf)
