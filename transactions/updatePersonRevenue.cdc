import MeloMint from 0xMeloMint

transaction(revenue: Int) {
    prepare(signer: AuthAccount) {
        MeloMint.changePersonRevenue(person: signer, revenue: revenue)
    }
}