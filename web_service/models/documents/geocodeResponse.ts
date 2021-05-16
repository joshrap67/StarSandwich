export interface GeocodeResponse {
	input: object;
	results: Location[];
}

interface Location {
	address_components: [];
	formatted_address: string;
	location: GeocodeCoordinates;
	accuracy: number;
	accuracy_type: string;
	source: string;
}

interface GeocodeCoordinates {
	lat: number;
	lng: number;
}