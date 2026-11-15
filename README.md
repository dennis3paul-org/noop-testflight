# NOOP to TestFlight

Builds [NOOP](https://github.com/ryanbr/noop) in GitHub Actions and uploads it
to your own TestFlight, with no Mac and no Xcode. It works the same way as the
Loop and Trio "browser build" and reuses the same six secrets and the same
`Match-Secrets` repository.

A build made this way is signed by your own Apple Developer team, so it
includes the Apple Watch app and Apple Health (HealthKit) access, and it does
not need re-signing every seven days.

The NOOP source code is not stored here. Every build fetches it fresh from
`ryanbr/noop`.

## What you need

- A paid Apple Developer account.
- These secrets, available to this repository. If you already build Loop or
  Trio in the same GitHub organization, they are already there:
  `TEAMID`, `FASTLANE_ISSUER_ID`, `FASTLANE_KEY_ID`, `FASTLANE_KEY`, `GH_PAT`,
  `MATCH_PASSWORD`.

## First-time setup

Run the numbered workflows from the **Actions** tab, in order.

1. **1. Validate Secrets**. Checks the six secrets.
2. **2. Add Identifiers**. Registers the four NOOP identifiers with Apple.
3. **One-time Apple setup** (below). Two things Apple only allows by hand.
4. **3. Create Certificates**. Creates the provisioning profiles.
5. **4. Build NOOP**. Builds and uploads to TestFlight. About 30 to 60 minutes.

### One-time Apple setup

`TEAMID` below is your 10-character Apple Team ID.

**Create the App Group**

1. Open [Register an App Group](https://developer.apple.com/account/resources/identifiers/applicationGroup/add/).
2. Description: `NOOP App Group`
3. Identifier: `group.com.TEAMID.noop.staging`
4. Continue, then Register.

**Add the App Group to the four identifiers**

1. Open the [Identifiers list](https://developer.apple.com/account/resources/identifiers/list).
2. For each of the four rows below: click it, find **App Groups**, click
   **Configure** (or **Edit**), tick **NOOP App Group**, then Continue, Save,
   Confirm.

| Name | Identifier |
|---|---|
| NOOP | `com.TEAMID.noop` |
| NOOP Widgets | `com.TEAMID.noop.widgets` |
| NOOP Watch | `com.TEAMID.noop.watch` |
| NOOP Watch Complications | `com.TEAMID.noop.watch.complications` |

**Create the app in App Store Connect**

1. Open [App Store Connect, Apps](https://appstoreconnect.apple.com/apps), click **+**, then **New App**.
2. Platform: iOS.
3. Name: anything not already taken on the App Store, for example
   `NOOP` followed by your initials. This is not the name on your home screen.
4. Bundle ID: the one that ends in `.noop` (not `.widgets` or `.watch`).
5. SKU: anything, for example `noop`.
6. User Access: Full Access. Then Create.

If you change the App Group or the identifiers later, run
**3. Create Certificates** again.

### Install on your iPhone

In App Store Connect open the app, then **TestFlight**, then **Internal
Testing**, add a group and add yourself. Install the TestFlight app on your
iPhone and accept the invitation. New builds then show up there on their own.
The Apple Watch app installs from the Watch app on your iPhone.

## Automatic builds

**4. Build NOOP** also runs by itself every Saturday. It builds when NOOP has
published a new release, and at least every four weeks so the TestFlight build
(which expires after 90 days) never runs out. When there is nothing to do, the
run shows as cancelled (grey). A green check always means a new build was
uploaded.

Optional variables (Settings, Secrets and variables, Actions, Variables):

| Variable | Effect |
|---|---|
| `NOOP_REF` | What the scheduled build uses. Empty means the newest NOOP release. Set it to `main` to follow NOOP's development branch, or to a tag such as `v12.0.0` to stay on one version. |
| `SCHEDULED_SYNC` | Set to `false` to stop building when NOOP has a new version. |
| `SCHEDULED_BUILD` | Set to `false` to stop the four-weekly refresh build. |
| `ENABLE_NUKE_CERTS` | Set to `true` to let the build renew your Distribution certificate when it has expired (once a year). This revokes and recreates the certificate for all your browser-build apps, exactly as Loop and Trio do. |

To build a specific version once, start **4. Build NOOP** by hand and type a
tag or branch into the box.

## Good to know

- **Bundle IDs.** The app is built as `com.TEAMID.noop`, so it installs beside
  any other copy of NOOP.
- **Build numbers.** NOOP's own build number is kept when it is new to your
  TestFlight. A rebuild of the same version counts up by one instead.
- **Export compliance.** The build adds `ITSAppUsesNonExemptEncryption = false`
  to the app, which tells Apple that NOOP only uses the encryption built into
  iOS. Without it every build waits for you to answer that question by hand in
  App Store Connect.
- **Testers.** Keep this to internal testing (you and people on your Apple
  team). NOOP's license allows personal and non-commercial use only, and an
  external TestFlight link needs Apple's beta review.
- **Privacy.** This repository is public, like a Loop or Trio fork. Secrets
  are hidden in the logs, and the build skips the fastlane tables that would
  print the certificate holder's name.
- **Not affiliated.** NOOP is an independent project and is not a medical
  device. This repository only automates building it.

## Credits

The workflows are adapted from the Trio and Loop browser build. See
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
