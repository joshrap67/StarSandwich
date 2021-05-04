from csv import reader
from array import *
import math

RA_OFFSET = (0.35) * 2
DEC_OFFSET = (1.5) * 2
DEC_ORIGIN = -90
MAX_RA_BIN = math.ceil(24.0 / RA_OFFSET)  # starting from bin = 0 of course
MAX_DEC_BIN = math.ceil(180.0 / DEC_OFFSET)  # starting from bin = 0 of course


def determinePrecision():
    histogram_3d = list()
    histogram_3d = [[[] for x in range(MAX_DEC_BIN)]
                    for x in range(MAX_RA_BIN)]

    with open('data_ra_dec_only.csv', 'r') as file:
        rows = reader(file)
        for row in rows:
            # find right ascension bin coordinate
            RA_value = float(row[0])
            RA_bin_cord = calculateRightAscensionBin(RA_value)

            # find declination bin coordinate
            dec_value = float(row[1])
            dec_bin_cord = calculateDeclinationBin(dec_value)

            histogram_3d[RA_bin_cord][dec_bin_cord].append(row)

    bad_points = getNumberOfBadPoints(histogram_3d)
    totalPoints = MAX_DEC_BIN * MAX_RA_BIN
    percentage = (bad_points / totalPoints) * 100
    print("Total points that do not have any stars from the database: {}".format(bad_points))
    print("Total squares the sky was split into: {}".format(totalPoints))
    print("Percentage: {}".format(percentage))


def getNumberOfBadPoints(histogram):
    bad_points = 0
    for RA in range(0, MAX_RA_BIN):
        for dec in range(0, MAX_DEC_BIN):
            if len(histogram[RA][dec]) == 0:
                bad_points += 1
    return bad_points


def calculateRightAscensionBin(point):
    return math.floor(point / RA_OFFSET)


def calculateDeclinationBin(point):
    return math.floor((point - DEC_ORIGIN) / DEC_OFFSET)


if __name__ == '__main__':
    determinePrecision()
