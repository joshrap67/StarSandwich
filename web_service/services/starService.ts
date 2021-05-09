import {StarRepository} from "../repositories/starRepository";
import MakeStarSandwichModel from "../models/requests/makeStarSandwichModel";
import {OptimalStarService} from "./optimalStarService";
import {StarSandwichResponse} from "../models/responses/starSandwichResponse";
import {starToResponse} from "../models/maps/starMaps";

export default class StarService {
	static async makeStarSandwich(model: MakeStarSandwichModel): Promise<StarSandwichResponse> {
		let antipodeLongitude = model.coordinates.longitude;
		if (model.coordinates.longitude > 0) {
			antipodeLongitude -= 180;
		} else if (model.coordinates.longitude <= 0) {
			antipodeLongitude += 180;
		}

		const rightAscensionTop = this.getRightAscensionInHours(model.coordinates.longitude);
		const rightAscensionBottom = this.getRightAscensionInHours(antipodeLongitude);

		const topStarCandidates = await StarRepository.findStars([rightAscensionTop, model.coordinates.latitude]);
		const bottomStarCandidates = await StarRepository.findStars([rightAscensionBottom, -model.coordinates.latitude]);

		const starAbove = topStarCandidates.length > 0
			? OptimalStarService.findOptimalStar(rightAscensionTop, model.coordinates.latitude, topStarCandidates)
			: null;
		const starBelow = bottomStarCandidates.length > 0
			? OptimalStarService.findOptimalStar(rightAscensionTop, model.coordinates.latitude, bottomStarCandidates)
			: null;

		return {
			starAbove: starAbove != null ? starToResponse(starAbove) : null,
			starBelow: starBelow != null ? starToResponse(starBelow) : null
		};
	}

	private static getRightAscensionInHours(longitude: number): number {
		const greenwichSiderealTimeDegrees = this.getMeanGreenwichSiderealTimeDegrees();
		const localSiderealTime = (longitude + greenwichSiderealTimeDegrees) / 15;

		let rightAscension = localSiderealTime;
		if (localSiderealTime < 0) {
			// this is such a hack and would love to find an astronomer to help me understand XD
			rightAscension = 24 - (Math.abs(localSiderealTime));
		}
		return rightAscension; // hrs
	}

	private static getMeanGreenwichSiderealTimeDegrees(): number {
		const now = new Date();
		const julianDays = this.getJulianDays(now);

		const T = (julianDays - 2451545.0) / 36525; // Julian centuries
		const greenwichSiderealAngle =
			280.46061837 +
			360.98564736629 * (julianDays - 2451545.0) +
			0.000387933 * Math.pow(T, 2) -
			(Math.pow(T, 3) * Math.pow(2.6, -8));

		return greenwichSiderealAngle % 360;
	}

	private static getJulianDays(timestamp: Date) {
		return timestamp.getTime() / 86400000 + 2440587.5;
	}
}