from csv import reader
from array import *
import math
import os

FILE = 'data_ra_dec_only_all_constellations.csv'
RA_OFFSET = 0.25  # in hours
DEC_OFFSET = 2.5  # in degrees
DEC_ORIGIN = -90
# starting from bin = 0 of course
RA_PARTITIONS = math.ceil(24.0 / RA_OFFSET)
# starting from bin = 0 of course
DEC_PARTITIONS = math.ceil(180.0 / DEC_OFFSET)


def determine_precision():
    histogram = get_histogram()

    bad_points = get_number_of_bad_points(histogram)
    total_points = DEC_PARTITIONS * RA_PARTITIONS
    percentage = (bad_points / total_points) * 100
    RA_to_degrees = RA_OFFSET * 15

    # os.system('cls')
    print("----------------Finished computing----------------")
    print("Max dec index {}".format(DEC_PARTITIONS))
    print("Max RA index {}".format(RA_PARTITIONS))
    print("Right ascension range: {} hrs ({}°)".format(
        RA_OFFSET, RA_to_degrees))
    print("Declination range: {}°".format(DEC_OFFSET))
    print("Total rectangles that do not have any stars from the database: {}".format(
        bad_points))
    print("Total rectangles the sky was split into: {}".format(total_points))
    print("Percentage of rectangles without stars: {}%".format(percentage))


def get_histogram():
    histogram_3d = [[[] for x in range(DEC_PARTITIONS)]
                    for x in range(RA_PARTITIONS)]

    with open(FILE, 'r') as file:
        rows = reader(file)
        for row in rows:
            # find right ascension upper and lower bound coordinate
            RA_value = float(row[0])
            RA_upper_coord = right_ascension_upper_bound_bin(RA_value)
            RA_lower_coord = right_ascension_lower_bound_bin(RA_value)

            # find declination upper and lower bound coordinate
            dec_value = float(row[1])
            dec_upper_coord = declination_upper_bound_bin(dec_value)
            dec_lower_coord = declination_lower_bound_bin(dec_value)

            histogram_3d[RA_upper_coord][dec_upper_coord].append(row)
            histogram_3d[RA_lower_coord][dec_lower_coord].append(row)
    return histogram_3d


def get_number_of_bad_points(histogram):
    bad_points = 0
    for RA in range(0, RA_PARTITIONS):
        for dec in range(0, DEC_PARTITIONS):
            if len(histogram[RA][dec]) == 0:
                print("{} {}".format(RA, dec))
                bad_points += 1
    return bad_points


def right_ascension_upper_bound_bin(point):
    return math.floor((point / RA_OFFSET))


def right_ascension_lower_bound_bin(point):
    return math.ceil((point / RA_OFFSET) - 1)


def declination_upper_bound_bin(point):
    return math.floor(((point - DEC_ORIGIN) / DEC_OFFSET))


def declination_lower_bound_bin(point):
    return math.ceil(((point - DEC_ORIGIN) / DEC_OFFSET) - 1)


if __name__ == '__main__':
    determine_precision()
