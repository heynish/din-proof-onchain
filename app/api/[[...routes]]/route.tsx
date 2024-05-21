/** @jsxImportSource frog/jsx */

import { Button, Frog, TextInput } from 'frog'
import { devtools } from 'frog/dev'
// import { neynar } from 'frog/hubs'
import { handle } from 'frog/next'
import { serveStatic } from 'frog/serve-static'
import { addToWhiteList, mintNFT } from '../../core/phosphor'
import { neynar } from 'frog/middlewares'

const neynarMiddleware = neynar({
  apiKey: 'NEYNAR_FROG_FM',
  features: ['interactor', 'cast'],
})

const app = new Frog({
  assetsPath: '/',
  basePath: '/api',
  // Supply a Hub to enable frame verification.
  // hub: neynar({ apiKey: 'NEYNAR_FROG_FM' })
})

// Uncomment to use Edge Runtime
// export const runtime = 'edge'

app.frame('/', async (c) => {
  return c.res({
    action: '/faucet',
    image: '/ETHBerlin-2024_Farcaster-Frames_01.png',
    intents: [
      <Button value="get-started">Get Started</Button>,
    ]
  })
})

app.frame('/faucet', async (c) => {
  return c.res({
    action: '/dili',
    image: '/ETHBerlin-2024_Farcaster-Frames_02.png',
    intents: [
      <Button.Link href="https://app.infura.io/register">Sign up</Button.Link>,
      <Button.Link href="https://www.infura.io/faucet/linea">Claim ETH</Button.Link>,
      <Button value="next">CTF and NFT mint</Button>,
    ]
  })
})

app.frame('/dili', async (c) => {
  const content = () => (
    <p style={{ fontSize: 26 }}>Solve the puzzle in the code of the contract linked below to get the secret.</p>
  );
  return c.res({
    image: '/ETHBerlin-2024_Farcaster-Frames_03.png',
    intents: [
      <TextInput placeholder="Enter the secret..." />,
      <Button.Link href={process.env.CONTRACT_URL?.toString() ?? ''}>Puzzle Contract</Button.Link>,
      <Button action='/verify' value="next">Submit Answer</Button>,
    ]
  })
})


app.frame('/verify', neynarMiddleware,
  async (c) => {
    const { inputText } = c
    // Verify Dili Secret
    if (inputText !== process.env.DILI_SECRET) {
      return c.res({
        action: '/verify',
        image: '/ETHBerlin-2024_Farcaster-Frames_04.png',
        intents: [
          <TextInput placeholder="Enter the secret..." />,
          <Button.Link href={process.env.CONTRACT_URL?.toString() ?? ''}>Puzzle Contract</Button.Link>,
          <Button value="next">Submit Answer</Button>,
        ]
      })
    }
    return c.res({
      image: '/ETHBerlin-2024_Farcaster-Frames_06.png',
      action: '/mint',
      intents: [
        <Button value="mint">Mint</Button>,
      ]
    })
  })

app.frame('/mint', neynarMiddleware,
  async (c) => {
    try {
      const addresses = c.var.interactor?.verifiedAddresses?.ethAddresses || [];
      // if addresses[0] is empty then use the custodyAddress
      const address = addresses.length > 0 && addresses[0] ? addresses[0] : c.var.interactor?.custodyAddress || "";
      const listing_id = process.env.LISTING_ID?.toString() || '';
      await addToWhiteList(address, listing_id);
      await mintNFT(address, listing_id);

      stayIdle(1000);
      return c.res({
        image: '/ETHBerlin-2024_Farcaster-Frames_11.png',
      })
    } catch (e: any) {
      console.log(e);
      return c.res({
        action: '/',
        image: '/ETHBerlin-2024_Farcaster-Frames_error.png',
        intents: [<Button>Back to Home</Button>],
      });
    }
  })

export const stayIdle = (delayInMs: number) =>
  new Promise((resolve) => setTimeout(resolve, delayInMs));

devtools(app, { serveStatic })

export const GET = handle(app)
export const POST = handle(app)
