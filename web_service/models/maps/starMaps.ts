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
		constellation: constellationsMap.get(star.constellation),
		bfDesignation: star.bfDesignation.replace(/\s+/g, ' ').trim(),
		rightAscension: star.rightAscension,
		declination: star.declination,
		magnitude: star.magnitude,
		numStars: star.numStars,
		distance: star.distance,
		absMagnitude: star.absMagnitude,
		luminosity: star.luminosity
	}
}

const constellationsMap = new Map([
	['And', 'Andromeda'],
	['Ant', 'Antila'],
	['Aps', 'Apus'],
	['Aqr', 'Aquarius'],
	['Aql', 'Aquila'],
	['Ara', 'Ara'],
	['Ari', 'Aries'],
	['Aur', 'Auriga'],
	['Boo', 'Bootes'],
	['Cae', 'Caelum'],
	['Cam', 'Camelopardalis'],
	['Cnc', 'Cancer'],
	['CVn', 'Canes Venatici'],
	['CMa', 'Canis Major'],
	['CMi', 'Canis Minor'],
	['Cap', 'Capricornus'],
	['Car', 'Carina'],
	['Cas', 'Cassiopeia'],
	['Cen', 'Centaurus'],
	['Cep', 'Cepheus'],
	['Cet', 'Cetus'],
	['Cha', 'Chamaeleon'],
	['Cir', 'Circinus'],
	['Col', 'Columba'],
	['Com', 'Coma Berenices'],
	['CrA', 'Corona Australis'],
	['CrB', 'Corona Borealis'],
	['Crv', 'Corvus'],
	['Crt', 'Crater'],
	['Cru', 'Crux'],
	['Cyg', 'Cygnus'],
	['Del', 'Delphinus'],
	['Dor', 'Dorado'],
	['Dra', 'Draco'],
	['Equ', 'Equuleus'],
	['Eri', 'Eridanus'],
	['For', 'Fornax'],
	['Gem', 'Gemini'],
	['Gru', 'Grus'],
	['Her', 'Hercules'],
	['Hor', 'Horologium'],
	['Hya', 'Hydra'],
	['Hyi', 'Hydrus'],
	['Ind', 'Indus'],
	['Lac', 'Lacerta'],
	['Leo', 'Leo'],
	['LMi', 'Leo Minor'],
	['Lep', 'Lepus'],
	['Lib', 'Libra'],
	['Lup', 'Lupus'],
	['Lyn', 'Lynx'],
	['Lyr', 'Lyra'],
	['Men', 'Mensa'],
	['Mic', 'Microscopium'],
	['Mon', 'Monoceros'],
	['Mus', 'Musca'],
	['Nor', 'Norma'],
	['Oct', 'Octans'],
	['Oph', 'Ophiuchus'],
	['Ori', 'Orion'],
	['Pav', 'Pavo'],
	['Peg', 'Pegasus'],
	['Per', 'Perseus'],
	['Phe', 'Phoenix'],
	['Pic', 'Pictor'],
	['Psc', 'Pisces'],
	['PsA', 'Piscis Austrinus'],
	['Pup', 'Puppis'],
	['Pyx', 'Pyxis'],
	['Ret', 'Reticulum'],
	['Sge', 'Sagitta'],
	['Sgr', 'Sagittarius'],
	['Sco', 'Scorpius'],
	['Scl', 'Sculptor'],
	['Sct', 'Scutum'],
	['Ser', 'Serpens'],
	['Sex', 'Sextans'],
	['Tau', 'Taurus'],
	['Tel', 'Telescopium'],
	['Tri', 'Triangulum'],
	['TrA', 'Triangulum Australe'],
	['Tuc', 'Tucana'],
	['UMa', 'Ursa Major'],
	['UMi', 'Ursa Minor'],
	['Vel', 'Vela'],
	['Vir', 'Virgo'],
	['Vol', 'Volans'],
	['Vul', 'Vulpecula']
]);