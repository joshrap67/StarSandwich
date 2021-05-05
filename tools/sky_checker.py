from csv import reader
from array import *
import math
import os

RA_OFFSET = (0.25) * 2  # in hours
DEC_OFFSET = (2.5) * 2  # in degrees
DEC_ORIGIN = -90
MAX_RA_BIN = math.ceil(24.0 / RA_OFFSET)  # starting from bin = 0 of course
MAX_DEC_BIN = math.ceil(180.0 / DEC_OFFSET)  # starting from bin = 0 of course


def determine_precision():
    histogram = get_histogram()

    bad_points = get_number_of_bad_points(histogram)
    total_points = MAX_DEC_BIN * MAX_RA_BIN
    percentage = (bad_points / total_points) * 100
    RA_to_degrees = (RA_OFFSET / 2) * 15

    os.system('cls')
    print("----------------Finished computing----------------")
    print("Right ascension range: {} hrs ({}°)".format(
        RA_OFFSET / 2, RA_to_degrees))
    print("Declination range: {}°".format(DEC_OFFSET / 2))
    print("Total squares that do not have any stars from the database: {}".format(
        bad_points))
    print("Total squares the sky was split into: {}".format(total_points))
    print("Percentage of squares without stars: {}%".format(percentage))


def get_histogram():
    histogram_3d = list()
    histogram_3d = [[[] for x in range(MAX_DEC_BIN)]
                    for x in range(MAX_RA_BIN)]

    with open('data_ra_dec_only_all_constellations.csv', 'r') as file:
        rows = reader(file)
        for row in rows:
            # find right ascension bin coordinate
            RA_value = float(row[0])
            RA_bin_cord = calculate_right_ascension_bin(RA_value)

            # find declination bin coordinate
            dec_value = float(row[1])
            dec_bin_cord = calculate_declination_bin(dec_value)

            histogram_3d[RA_bin_cord][dec_bin_cord].append(row)
    return histogram_3d


def get_number_of_bad_points(histogram):
    bad_points = 0
    for RA in range(0, MAX_RA_BIN):
        for dec in range(0, MAX_DEC_BIN):
            if len(histogram[RA][dec]) == 0:
                bad_points += 1
    return bad_points


def calculate_right_ascension_bin(point):
    return math.floor(point / RA_OFFSET)


def calculate_declination_bin(point):
    return math.floor((point - DEC_ORIGIN) / DEC_OFFSET)


if __name__ == '__main__':
    determine_precision()
