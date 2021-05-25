from csv import reader
from array import *
import math
import os

FILE = 'data_ra_dec_only_all_constellations.csv'
# current best for 100% coverage: RA .19, DEC: 2.5
RIGHT_ASCENSION_RANGE = 0.1  # in hours
DECLINATION_RANGE = 1.0  # in degrees
DECLINATION_ORIGIN = -90
# starting from origin = 0 of course
MAX_RIGHT_ASCENSION_INDEX = math.ceil(24.0 / RIGHT_ASCENSION_RANGE)
# starting from origin = 0 of course
MAX_DECLINATION_INDEX = math.ceil(180.0 / DECLINATION_RANGE)
latitude_values = dict()


def find_optimal_values():
    # todo fix this?
    ra_offset = 0.01

    best_ra_offset = ra_offset
    best_dec_offset = 0
    emergency_break = False

    while(ra_offset < 1 and not emergency_break):
        # anything bigger than this is pointless
        dec_offset = 0.5
        while(dec_offset < 5):
            RIGHT_ASCENSION_RANGE = ra_offset
            DECLINATION_RANGE = dec_offset
            grid = get_cartesian_grid()
            bad_points = get_number_of_bad_points(grid)
            if bad_points == 0:
                best_dec_offset = dec_offset
                best_ra_offset = ra_offset
                emergency_break = True
                break
            dec_offset += 0.1
        print('Right ascension {} done'.format(ra_offset))
        ra_offset += 0.01
    print("Optimal right ascension range: {}\nOptimal declination range: {}".format(
        best_ra_offset, best_dec_offset))


def determine_precision():
    grid = get_cartesian_grid()

    bad_points = get_number_of_bad_points(grid)
    total_points = MAX_DECLINATION_INDEX * MAX_RIGHT_ASCENSION_INDEX
    percentage = (bad_points / total_points) * 100
    RA_to_degrees = RIGHT_ASCENSION_RANGE * 15

    os.system('cls')
    print("----------------Finished computing----------------")
    print("Max dec index {}".format(MAX_DECLINATION_INDEX))
    print("Max RA index {}".format(MAX_RIGHT_ASCENSION_INDEX))
    print("Right ascension range: {} hrs ({}°)".format(
        RIGHT_ASCENSION_RANGE, RA_to_degrees))
    print("Declination range: {}°".format(DECLINATION_RANGE))
    print("Total rectangles that do not have any stars from the database: {}".format(
        bad_points))
    print("Total rectangles the sky was split into: {}".format(total_points))
    print("Percentage of rectangles without stars: {}%".format(percentage))
    if len(latitude_values) > 0:
        sorted(latitude_values)  # python wtf you're amazing
        for lat in latitude_values:
            lower_range = lat + 1
            print("{} rectangles without stars at latitude ranges {}° {}°".format(
                latitude_values[lat], lat, lower_range))


def get_cartesian_grid():
    cartesian_grid = [[[] for x in range(MAX_DECLINATION_INDEX)]
                      for x in range(MAX_RIGHT_ASCENSION_INDEX)]

    with open(FILE, 'r') as file:
        rows = reader(file)
        for row in rows:
            # find right ascension right, center, and left coordinates
            RA_value = float(row[0])
            RA_right_coord = right_ascension_upper_bound_coordinate(RA_value)
            RA_center_coord = right_ascension_center_coordinate(RA_value)
            RA_left_coord = right_ascension_lower_bound_coordinate(RA_value)

            # find declination upper, center, and lower coordinates
            dec_value = float(row[1])
            dec_upper_coord = declination_upper_bound_coordinate(dec_value)
            dec_center_coord = declination_center_coordinate(dec_value)
            dec_lower_coord = declination_lower_bound_coordinate(dec_value)

            # construct the rectangles that this star can be found in
            # upper left
            if(isValidDeclinationCoordinate(dec_upper_coord) and isValidRightAscensionCoordinate(RA_left_coord)):
                cartesian_grid[RA_left_coord][dec_upper_coord].append(row)

            # middle left
            if(isValidDeclinationCoordinate(dec_center_coord) and isValidRightAscensionCoordinate(RA_left_coord)):
                cartesian_grid[RA_left_coord][dec_center_coord].append(row)

             # bottom left
            if(isValidDeclinationCoordinate(dec_lower_coord) and isValidRightAscensionCoordinate(RA_left_coord)):
                cartesian_grid[RA_left_coord][dec_lower_coord].append(row)

             # upper middle
            if(isValidDeclinationCoordinate(dec_upper_coord) and isValidRightAscensionCoordinate(RA_center_coord)):
                cartesian_grid[RA_center_coord][dec_upper_coord].append(row)

            # middle
            if(isValidDeclinationCoordinate(dec_center_coord) and isValidRightAscensionCoordinate(RA_center_coord)):
                cartesian_grid[RA_center_coord][dec_center_coord].append(row)

            # lower middle
            if(isValidDeclinationCoordinate(dec_lower_coord) and isValidRightAscensionCoordinate(RA_center_coord)):
                cartesian_grid[RA_center_coord][dec_lower_coord].append(row)

            # upper right
            if(isValidDeclinationCoordinate(dec_upper_coord) and isValidRightAscensionCoordinate(RA_right_coord)):
                cartesian_grid[RA_right_coord][dec_upper_coord].append(row)

            # middle right
            if(isValidDeclinationCoordinate(dec_center_coord) and isValidRightAscensionCoordinate(RA_right_coord)):
                cartesian_grid[RA_right_coord][dec_center_coord].append(row)

            # lower right
            if(isValidDeclinationCoordinate(dec_lower_coord) and isValidRightAscensionCoordinate(RA_right_coord)):
                cartesian_grid[RA_right_coord][dec_lower_coord].append(row)
    return cartesian_grid


def get_number_of_bad_points(grid):
    bad_points = 0
    for RA in range(0, MAX_RIGHT_ASCENSION_INDEX):
        for dec in range(0, MAX_DECLINATION_INDEX):
            if len(grid[RA][dec]) == 0:
                latitude_lower_range = dec * DECLINATION_RANGE - 90
                latitude_values[latitude_lower_range] = latitude_values.get(
                    latitude_lower_range, 0) + 1
                bad_points += 1
    return bad_points


def isValidDeclinationCoordinate(declinationIndex):
    return declinationIndex >= 0 and declinationIndex < MAX_DECLINATION_INDEX


def isValidRightAscensionCoordinate(rightAscensionIndex):
    return rightAscensionIndex >= 0 and rightAscensionIndex < MAX_RIGHT_ASCENSION_INDEX


def right_ascension_upper_bound_coordinate(point):
    return math.floor((point / RIGHT_ASCENSION_RANGE) + 1)


def right_ascension_center_coordinate(point):
    return math.floor((point / RIGHT_ASCENSION_RANGE))


def right_ascension_lower_bound_coordinate(point):
    return math.floor((point / RIGHT_ASCENSION_RANGE) - 1)


def declination_upper_bound_coordinate(point):
    return math.floor(((point - DECLINATION_ORIGIN) / DECLINATION_RANGE) + 1)


def declination_center_coordinate(point):
    return math.floor(((point - DECLINATION_ORIGIN) / DECLINATION_RANGE))


def declination_lower_bound_coordinate(point):
    return math.floor(((point - DECLINATION_ORIGIN) / DECLINATION_RANGE) - 1)


if __name__ == '__main__':
    # find_optimal_values()
    determine_precision()
