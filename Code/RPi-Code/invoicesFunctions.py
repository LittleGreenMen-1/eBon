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

courierFont = "Courier"

# we don't really need this because it is just a simple receipts which
# does not require personal information of the customer

def buildItemizedDescriptionTable(products):
    # the invoice variables
    subtotal, discounts, taxes, total = 0, 0, 0, 0

    numberOfProducts = len(products)

    table_001 = Table(number_of_rows=int(numberOfProducts + 5), number_of_columns=4)
    for h in ["DESCRIPTION", "QTY", "UNIT PRICE", "AMOUNT"]:
        table_001.add(
            TableCell(
                Paragraph(h, font="Courier-bold", font_color = X11Color("White")),
                background_color = HexColor("016934"), # the green color
            )
        )

    # the colors off the table
    odd_color = HexColor("ebe9e0")
    even_color = HexColor("f5f4f0")

    # [("Product 1", 2, 50), ("Product 2", 4, 60), ("Labor", 14, 60)]

    # the products that will appear on the receipt
    for row_number, item in enumerate(products):
        # selecting the background color for the rows
        if row_number % 2 == 0:
            c = even_color
        else :
            c = odd_color

        # in case if the product is a discount
        if item[0] == "DISCOUNT":
            discounts += item[1] * item[2]

        subtotal += item[1] * item[2]

        table_001.add(TableCell(Paragraph(item[0], font=courierFont), background_color=c))
        table_001.add(TableCell(Paragraph(str(item[1]), font=courierFont), background_color=c))
        table_001.add(TableCell(Paragraph("$ " + str(item[2]), font=courierFont), background_color=c))
        table_001.add(TableCell(Paragraph("$ " + str(item[1] * item[2]), font=courierFont), background_color=c))

    """
    # Optionally add some empty rows to have a fixed number of rows for styling purposes
    for row_number in range(3, 10):
        c = even_color if row_number % 2 == 0 else odd_color
        for _ in range(0, 4):
            table_001.add(TableCell(Paragraph(" "), background_color=c))
    """

    table_001.add(
        TableCell(Paragraph("Subtotal", font="Courier-bold", horizontal_alignment=Alignment.RIGHT, ), col_span=3, ))
    table_001.add(TableCell(Paragraph(f"$ {subtotal}", font=courierFont, horizontal_alignment=Alignment.RIGHT)))

    table_001.add(
        TableCell(Paragraph("Discounts", font="Courier-bold", horizontal_alignment=Alignment.RIGHT, ), col_span=3, ))
    table_001.add(TableCell(Paragraph(f"$ -{discounts}", font=courierFont, horizontal_alignment=Alignment.RIGHT)))

    table_001.add(
        TableCell(Paragraph("Taxes", font="Courier-bold", horizontal_alignment=Alignment.RIGHT), col_span=3, ))
    table_001.add(TableCell(Paragraph(f"$ {taxes}", font=courierFont, horizontal_alignment=Alignment.RIGHT)))

    table_001.add(
        TableCell(Paragraph("Total", font="Courier-bold", horizontal_alignment=Alignment.RIGHT), col_span=3, ))
    table_001.add(TableCell(Paragraph(f"$ {subtotal-discounts+taxes}", font=courierFont, horizontal_alignment=Alignment.RIGHT)))

    table_001.set_padding_on_all_cells(Decimal(2), Decimal(2), Decimal(2), Decimal(2))
    table_001.no_borders()

    return table_001

def generateRandomReceiptNumber():
    number = 0
    for i in range(6):
        number += random.randint(0, 10)
        number *= 10
    return number
