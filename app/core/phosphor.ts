//import 'dotenv/config';
export async function addToWhiteList( toAddress: string, listingId: string) {
  // mint-request
  const whitelistResponse = await fetch(
    `${process.env.PHOSPHOR_URL}/beta/listings/${listingId}/allow-list`,
    {
      method: 'POST',
      headers: buildHeaderAPIKey(),
      body: JSON.stringify({
        action: "ADD",
        eth_addresses: [toAddress]
      }),
    },
  );
  checkForErrors(whitelistResponse);
  const data = await whitelistResponse.json();
  if (data.error) {
    throw new Error(`Error during allowlist add: ${data.error.detail}`);
  }
  console.log(JSON.stringify(data));
}
export async function mintNFT(toAddress: string,listingId: string) {
  // mint-request
  const mintResponse = await fetch(
    `${process.env.PHOSPHOR_PUBLIC_URL}/v1/purchase-intents`,
    {
      method: 'POST',
      headers: buildHeaderNoAPIKey(),
      body: JSON.stringify({
        "provider": "ORGANIZATION",
        "listing_id": listingId,
        "quantity": 1,
        "buyer": {
              "eth_address": toAddress,
    }
      }),
    },
  );
  checkForErrors(mintResponse);
  const data = await mintResponse.json();
  if (data.error) {
    throw new Error(`Error during mint: ${data.error.detail}`);
  }
  console.log(JSON.stringify(data));
}



function checkForErrors(resp: Response) {
  if (resp.status === 401) {
    throw new Error('You are not authorized to access the API');
  }
  if (resp.status === 403) {
    throw new Error('You do not have access to this resource');
  }
}

function buildHeaderAPIKey(noContentType = false) {
  return {
    ...(!noContentType && { 'Content-Type': 'application/json' }),
    'Phosphor-Api-Key': `${process.env.PHOSPHOR_API_KEY}`,
  };
}

function buildHeaderNoAPIKey(noContentType = false) {
  return {
    ...(!noContentType && { 'Content-Type': 'application/json' }),
  };
}
