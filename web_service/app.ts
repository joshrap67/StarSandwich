import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import StarService from "./services/starService";

sandwich();

async function sandwich() {
  const starService = new StarService();
  const result = await starService.makeStarSandiwch({
    latitude: 0.0,
    longitude: 0.0,
  });
  console.log(result);
}

export const lambdaHandler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  const route = event.path;
  let response = null;
  if (route === "makeStarSandiwch") {
    const starService = new StarService();
    const request = JSON.parse(event.body) as MakeStarSandwichModel;
    response = await starService.makeStarSandiwch(request);
  }

  return {
    statusCode: 200,
    body: JSON.stringify(response),
  };
};
