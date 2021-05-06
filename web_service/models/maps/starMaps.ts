import {IStar} from "../documents/star";
import {StarResponse} from "../responses/starResponse";

export function starToResponse(star: IStar): StarResponse {
	return {
		id: star._id,
		hipId: star.hipId,
		hdId: star.hdId,
		hrId: star.hrId,
		glId: star.glId,
		properName: star.properName,
		constellation: star.constellation,
		bfDesignation: star.bfDesignation,
		rightAscension: star.rightAscension,
		declination: star.declination,
		magnitude: star.magnitude,
		numStars: star.numStars,
		distance: star.distance,
		absMagnitude: star.absMagnitude,
		luminosity: star.luminosity
	}
}