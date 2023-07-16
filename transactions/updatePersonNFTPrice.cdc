import MeloMint from 0xMeloMint

transaction(price: Int) {
    prepare(signer: AuthAccount) {
        MeloMint.changePersonNFTPrice(person: signer, price: price)
    }
}