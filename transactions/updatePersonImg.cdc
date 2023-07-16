import MeloMint from 0xMeloMint

transaction(img: String) {
    prepare(signer: AuthAccount) {
        MeloMint.updatePersonImage(personId: signer.address, img: img)
    }

    execute {
        log(MeloMint.getPeople())
    }
}