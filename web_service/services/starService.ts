import StarRepository from "../repositories/starRepository";
import MakeStarSandwichModel from "../models/requests/makeStarSandwichModel";
import OptimalStarService from "./optimalStarService";
import {StarSandwichResponse} from "../models/responses/starSandwichResponse";
import {starToResponse} from "../models/maps/starMaps";

export default class StarService {
	async makeStarSandwich(model: MakeStarSandwichModel): Promise<StarSandwichResponse> {
		const repo = new StarRepository();
		const RA = this.getRightAscensionInHours(model.coordinates.longitude);

		const topStarCandidates = await repo.findStars([RA, model.coordinates.latitude]);
		const bottomStarCandidates = await repo.findStars([RA, -model.coordinates.latitude]);

		const optimalService = new OptimalStarService();
		const starAbove = topStarCandidates.length > 0
			? optimalService.findOptimalStar(RA, model.coordinates.latitude, topStarCandidates)
			: null;
		const starBelow = bottomStarCandidates.length > 0
			? optimalService.findOptimalStar(RA, model.coordinates.latitude, bottomStarCandidates)
			: null;
		// todo constellation lookup

		return {
			starAbove: starToResponse(starAbove),
			starBelow: starToResponse(starBelow)
		};
	}

	getRightAscensionInHours(longitude: number): number {
		const LST = this.getLocalSiderealTimeInDegrees();
		return (longitude + LST) / 15; // hrs
	}

	getLocalSiderealTimeInDegrees(): number {
		const now = new Date();
		const julianDays = this.getJulianDays(now);

		const T = (julianDays - 2451545.0) / 36525; // Julian centuries
		const greenwichSiderealAngle =
			280.46061837 +
			360.98564736629 * (julianDays - 2451545.0) +
			0.000387933 * Math.pow(T, 2) -
			Math.pow(T, 3) / 38710000.0;

		return greenwichSiderealAngle % 360;
	}

	getJulianDays(timestamp: Date) {
		return timestamp.getTime() / 86400000 + 2440587.5;
	}
}
