# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Pre-Release V2

Enrich more contract Events - 
Add missing in-flight exit finalized event and more data to exisiting contract events
- feat: emit an event indicating that in-flight exit has finalized ([#647](https://github.com/omgnetwork/plasma-contracts/pull/647))
- feat: add outputTx to SE event ([#737](https://github.com/omgnetwork/plasma-contracts/pull/737))
- feat: add inputTx to IFE event ([#740](https://github.com/omgnetwork/plasma-contracts/pull/740))



---

- chore: cleanup unused accounts, make addresses consistent([#722](https://github.com/omgnetwork/plasma-contracts/pull/722), [#718](https://github.com/omgnetwork/plasma-contracts/pull/718))
- chore: add TOB audit report([#717](https://github.com/omgnetwork/plasma-contracts/pull/717))
- fix: migration if/else ([#716](https://github.com/omgnetwork/plasma-contracts/pull/716))
- chore: depbot upgrades([#715](https://github.com/omgnetwork/plasma-contracts/pull/715), [#721](https://github.com/omgnetwork/plasma-contracts/pull/721), [#727](https://github.com/omgnetwork/plasma-contracts/pull/727), [#725](https://github.com/omgnetwork/plasma-contracts/pull/725))
- fix: deployment with multisig and vault([#712](https://github.com/omgnetwork/plasma-contracts/pull/712))


---

Simplify Bond and Exit Bounty - [2020-10-23]
Have the Exit Bounty as a portion from the Exit Bond  
- docs: add Bond Design doc ([#702](https://github.com/omgnetwork/plasma-contracts/pull/702))
- [Process Exit Bounty] Bond and Bounty Simplification ([#707](https://github.com/omgnetwork/plasma-contracts/pull/707))


---

- chore: bump the vault version to the latest release ([#704](https://github.com/omgnetwork/plasma-contracts/pull/704))


---

Process Exit Bounty - [2020-08-31]
Incentivize calling processExit by rewarding the caller with a bounty provided by the exit owner  
- [Process Exit Bounty] Implement Bounty for Processing Exits consolidated ([#698](https://github.com/omgnetwork/plasma-contracts/pull/698))


---

- fix: deploy contracts serially and enable CI tests ([#700](https://github.com/omgnetwork/plasma-contracts/pull/700))
- fix: flaky python test for IFE process ([#695](https://github.com/omgnetwork/plasma-contracts/pull/695))


---

Enrich Contract Events - [2020-08-28]
Add more data to contract events
- docs: update integration docs for changed contract events ([#699](https://github.com/omgnetwork/plasma-contracts/pull/699))
- feat: enrich contract events to contain data needed by child-chain and watcher ([#686](https://github.com/omgnetwork/plasma-contracts/pull/686))


---

- chore: depbot upgrades ([#687](https://github.com/omgnetwork/plasma-contracts/pull/687), [#688](https://github.com/omgnetwork/plasma-contracts/pull/688), [#692](https://github.com/omgnetwork/plasma-contracts/pull/692), [#689](https://github.com/omgnetwork/plasma-contracts/pull/689))


---

Multisig - [2020-08-21]
Add support for deploying contracts with multisig support and vault
- feat: estimate gas for multisig maintainer transactions ([#693](https://github.com/omgnetwork/plasma-contracts/pull/693))
- feat: support docker deploy for gnosis and vault ([#690](https://github.com/omgnetwork/plasma-contracts/pull/690))
- feat: add vault+authority ([#678](https://github.com/omgnetwork/plasma-contracts/pull/678))
- feat: Add gnosis multisig submodule ([#677](https://github.com/omgnetwork/plasma-contracts/pull/677))
- feat: remove child chain activation ([#679](https://github.com/omgnetwork/plasma-contracts/pull/679))
- feat: add start vault ([#676](https://github.com/omgnetwork/plasma-contracts/pull/676))
- feat: convert to two steps to setup exit game ([#667](https://github.com/omgnetwork/plasma-contracts/pull/667))


---

- fix: drop trimming of trailing text from linked result ([#669](https://github.com/omgnetwork/plasma-contracts/pull/669))
- fix: flaky python test ([#662](https://github.com/omgnetwork/plasma-contracts/pull/662))
- chore: depbot upgrade ([#657](https://github.com/omgnetwork/plasma-contracts/pull/657))
- chore: hdwallet version upgrade ([#655](https://github.com/omgnetwork/plasma-contracts/pull/655))
- fix: truffle test failure with dependency issue ([#651](https://github.com/omgnetwork/plasma-contracts/pull/651))
- feat: remove multi exit game experiment ([#650](https://github.com/omgnetwork/plasma-contracts/pull/650))


---

New Exit Id format - [2020-06-16]
Modify the size of exitId from 160 -> 168 bits
- feat: new exitId format ([#631](https://github.com/omgnetwork/plasma-contracts/pull/631))


---

- feat: deploy contracts to Rinkeby in CI ([#637](https://github.com/omgnetwork/plasma-contracts/pull/637))


## [1.0.5] - 2020-05-21
No contract code change, mainly dependency changes, CI improvement and private repo synchronization.
- chore: upgrade truffle and fix python linter ([#630](https://github.com/omisego/plasma-contracts/pull/630))
- chore: stabilize python tests ([#619](https://github.com/omisego/plasma-contracts/pull/619))
- feat: deploy payment v2 with experiment feature flag ([#616](https://github.com/omisego/plasma-contracts/pull/616))
- feat: auto syncing between public and private repo ([#615](https://github.com/omisego/plasma-contracts/pull/615))
- chore: check api token before submission + save to artifact ([#613](https://github.com/omisego/plasma-contracts/pull/613))
- test: check that inputs can not be exited from restarted ife after outputs finalized on processing the first ife ([#611](https://github.com/omisego/plasma-contracts/pull/611))
- chore: npm audit fix ([#610](https://github.com/omisego/plasma-contracts/pull/610))
- chore: depbot upgrades ([#608](https://github.com/omisego/plasma-contracts/pull/608), [#609](https://github.com/omisego/plasma-contracts/pull/609))
- fix: slow test exceed circle ci timeout limit ([#600](https://github.com/omisego/plasma-contracts/pull/600))
- docs: add more on transaction validity. ([#597](https://github.com/omisego/plasma-contracts/pull/597))

## [1.0.4] - 2020-03-10
- Fix broken canonicity in IFE processing. ([#591](https://github.com/omisego/plasma-contracts/pull/591))
- Fix in-flight exit input-spend-challenge using wrong index. ([#593](https://github.com/omisego/plasma-contracts/pull/593))
- Add document about block retrieval. ([#570](https://github.com/omisego/plasma-contracts/pull/570))

## [1.0.3] - 2020-02-18
- In-flight exit returns all unchallenged piggyback bonds even if user piggybacks the wrong canonicity. ([#585](https://github.com/omisego/plasma-contracts/pull/585))

## [1.0.2] - 2020-02-13

### Changed

- Start using "CHANGELOG.md"
- Event `BlockSubmitted` field `BlockNumber` renamed to `blknum` ([#581](https://github.com/omisego/plasma-contracts/pull/581))
- `ChallengeStandardExit`, `ChallengeOutputSpent`, `ChallengeInputSpent` take additional parameter - `senderData` ([#574](https://github.com/omisego/plasma-contracts/pull/574))
- `PaymentInFlightExitRouter.inFlightExits()` takes an array of in-flight exit IDs instead of a single ID ([#583](https://github.com/omisego/plasma-contracts/pull/583))
