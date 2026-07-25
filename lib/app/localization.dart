import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('fr')];
  static const delegate = _AppLocalizationsDelegate();

  bool get isFrench => locale.languageCode == 'fr';

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en'));
  }

  String get appTitle => 'Chekkam';
  String get languageEnglish => isFrench ? 'Anglais' : 'English';
  String get languageFrench => isFrench ? 'Français' : 'French';
  String get languageSwitcherLabel => isFrench ? 'Langue' : 'Language';
  String get goodMorning => isFrench ? 'Bonjour' : 'Good morning';
  String get goodAfternoon => isFrench ? 'Bon après-midi' : 'Good afternoon';
  String get goodEvening => isFrench ? 'Bonsoir' : 'Good evening';
  String get gotSomethingSuspicious =>
      isFrench ? 'VOUS AVEZ UN DOUTE ?' : 'GOT SOMETHING SUSPICIOUS?';
  String get pasteSuspicious => isFrench
      ? 'Collez un message, un lien, ou transférez-le depuis WhatsApp.'
      : 'Paste a message, a link, or forward it from WhatsApp.';
  String get pasteToCheck =>
      isFrench ? 'Coller pour vérifier' : 'Paste to check';
  String get verifyDocument =>
      isFrench ? 'Vérifier un document' : 'Verify a document';
  String get scanPinOrUpload =>
      isFrench ? 'Scanner, PIN ou fichier' : 'Scan, PIN, or upload';
  String get publicAlerts => isFrench ? 'Alertes publiques' : 'Public alerts';
  String get reviewedWarnings =>
      isFrench ? 'Avertissements vérifiés' : 'Reviewed warnings';
  String get comingSoon => isFrench ? 'Bientôt' : 'Coming soon';
  String get verifyEverywhere =>
      isFrench ? 'Vérifier partout' : 'Verify Everywhere';
  String get verifyEverywhereSubtitle => isFrench
      ? 'Une extension de navigateur pour vérifier les liens là où vous êtes déjà.'
      : 'A browser extension for checking links where you already are.';
  String get protectCommunities =>
      isFrench ? 'Protéger les communautés' : 'Protect Communities';
  String get protectCommunitiesSubtitle => isFrench
      ? 'Alertes locales modérées, en complément des services d’urgence.'
      : 'Moderated local safety alerts, alongside emergency services.';
  String get nextPhase => isFrench ? 'Phase suivante' : 'Next phase';

  String get checkMessage =>
      isFrench ? 'Vérifier un message' : 'Check a message';
  String get reportIntro => isFrench
      ? "Collez un message ou un lien suspect. Chekkam l'analyse pour estimer le risque d'arnaque. Le recevoir ne veut jamais dire que vous avez fait quelque chose de mal."
      : 'Paste a suspicious message or link. Chekkam will analyze it for scam risk. This never means you did anything wrong by receiving it.';
  String get text => isFrench ? 'Texte' : 'Text';
  String get link => isFrench ? 'Lien' : 'Link';
  String get pasteMessageHint =>
      isFrench ? 'Collez le message ici...' : 'Paste the message here...';
  String get analyze => isFrench ? 'Analyser' : 'Analyze';
  String get pasteOrTypeFirst => isFrench
      ? 'Collez ou tapez d’abord le contenu suspect.'
      : 'Paste or type the suspicious content first.';

  String get analysisResult =>
      isFrench ? "Résultat de l'analyse" : 'Analysis result';
  String get pendingReview =>
      isFrench ? 'En attente de revue' : 'Pending review';
  String get reportQueued => isFrench
      ? 'Ce signalement est en file d’attente pour revue. Revenez bientôt.'
      : 'This report is queued for review. Check back shortly.';
  String get whyWeThinkThis =>
      isFrench ? 'POURQUOI NOUS PENSONS CELA' : 'WHY WE THINK THIS';
  String get automatedFirstLook => isFrench
      ? 'Ceci est une première analyse automatique. Un analyste Chekkam examine chaque signalement avant toute action finale.'
      : 'This is an automated first look. A Chekkam analyst reviews every report before any final action is taken.';
  String get backToHome => isFrench ? "Retour à l'accueil" : 'Back to home';

  String riskLabel(String? level) {
    return switch (level) {
      'low' => isFrench ? 'Risque faible' : 'Low risk',
      'medium' => isFrench ? 'Risque moyen' : 'Medium risk',
      'high' => isFrench ? 'Risque élevé' : 'High risk',
      'critical' => isFrench ? 'Risque critique' : 'Critical risk',
      _ => pendingReview,
    };
  }

  String get verifyHubIntro => isFrench
      ? "Vérifiez si un certificat, une lettre ou un autre document officiel est authentique."
      : 'Check whether a certificate, letter, or other official document is genuine.';
  String get scanQrCode => isFrench ? 'Scanner le code QR' : 'Scan QR code';
  String get scanQrSubtitle => isFrench
      ? 'Utilisez la caméra pour scanner le code imprimé sur le document.'
      : 'Use the camera to scan the code printed on the document.';
  String get enterIdOrPin => isFrench ? 'Entrer ID ou PIN' : 'Enter ID or PIN';
  String get enterIdSubtitle => isFrench
      ? "Tapez l’ID de vérification ou le PIN affiché sur le document."
      : 'Type the verification ID or PIN shown on the document.';
  String get uploadPhotoOrFile =>
      isFrench ? 'Importer une photo ou un fichier' : 'Upload a photo or file';
  String get uploadPhotoSubtitle => isFrench
      ? 'Fonctionne aussi avec une photocopie ou un scan transféré.'
      : 'Works even for a photocopy or forwarded scan.';

  String get manualVerifyIntro => isFrench
      ? "Tapez l’ID de vérification (ex. CHK-4F7K-9QRT) ou le PIN à 6 chiffres imprimé sur le document."
      : 'Type the verification ID (e.g. CHK-4F7K-9QRT) or the 6-digit PIN printed on the document.';
  String get enterVerificationIdError => isFrench
      ? 'Entrez un ID de vérification ou un PIN.'
      : 'Enter a verification ID or PIN.';
  String get verify => isFrench ? 'Vérifier' : 'Verify';

  String get uploadDocument =>
      isFrench ? 'Importer un document' : 'Upload a document';
  String get chooseFileToCheck =>
      isFrench ? 'Choisir un fichier à vérifier' : 'Choose a file to check';
  String get uploadPrimerExplanation => isFrench
      ? 'Choisissez une photo ou un fichier du document. Seul ce fichier sera envoyé à Chekkam pour vérification.'
      : 'Pick a photo or file of the document. Only that one file is sent to Chekkam for verification.';
  String get uploadVerifyIntro => isFrench
      ? "Choisissez une photo ou un fichier du document. Chekkam le compare à l’original signé."
      : 'Choose a photo or file of the document. Chekkam compares it against the signed original.';
  String get verificationIdOptional => isFrench
      ? 'ID de vérification (facultatif, si connu)'
      : 'Verification ID (optional, if known)';
  String get chooseFile => isFrench ? 'Choisir un fichier' : 'Choose file';

  String get cameraAccess => isFrench ? 'Accès à la caméra' : 'Camera access';
  String get cameraPrimerExplanation => isFrench
      ? 'Chekkam a besoin de votre caméra pour scanner le code QR imprimé sur le document. Rien n’est enregistré ni téléversé : seul le code est lu.'
      : 'Chekkam needs your camera to scan the QR code printed on the document. Nothing is recorded or uploaded: only the code is read.';
  String get cameraNotGranted => isFrench
      ? "L'accès à la caméra n'a pas été accordé"
      : 'Camera access was not granted';
  String get manualStillAvailable => isFrench
      ? 'Vous pouvez quand même vérifier un document en tapant son ID ou son PIN.'
      : 'You can still verify a document by typing its ID or PIN instead.';
  String get enterIdInstead =>
      isFrench ? 'Entrer ID ou PIN à la place' : 'Enter ID or PIN instead';

  String get verificationResult =>
      isFrench ? 'Résultat de vérification' : 'Verification result';
  String verifyHeadline(String status) {
    return switch (status) {
      'genuine' => isFrench ? 'Authentique.' : 'Genuine.',
      'tampered' => isFrench ? 'Falsifié.' : 'Tampered.',
      'revoked' => isFrench ? 'Révoqué.' : 'Revoked.',
      _ => isFrench ? 'Introuvable.' : 'Not found.',
    };
  }

  String verifyGuidance(String status) {
    return switch (status) {
      'genuine' =>
        isFrench
            ? "Sa signature correspond aux dossiers de l’institution émettrice et le document n’a pas été révoqué."
            : "Its signature matches the issuing institution's records and has not been revoked.",
      'tampered' =>
        isFrench
            ? "Le contenu ne correspond pas à ce qui a été signé. Contactez l’institution émettrice avant de vous y fier."
            : 'The content does not match what was signed. Contact the issuing institution before relying on it.',
      'revoked' =>
        isFrench
            ? "L’institution émettrice a retiré ce document. Consultez la raison ci-dessous si elle est fournie."
            : 'The issuing institution withdrew this document. See the reason below if provided.',
      _ =>
        isFrench
            ? "Vérifiez l’ID ou le PIN, ou réessayez de scanner le code QR. Contactez l’institution émettrice si vous pensez qu’il s’agit d’une erreur."
            : 'Double-check the ID or PIN, or try scanning the QR code again. Contact the issuing institution if you believe this is a mistake.',
    };
  }

  String get issuedBy => isFrench ? 'Émis par' : 'Issued by';
  String get documentType => isFrench ? 'Type de document' : 'Document type';
  String get reason => isFrench ? 'Raison' : 'Reason';

  String get noActiveAlerts => isFrench
      ? 'Aucune alerte active pour le moment.'
      : 'No active alerts right now.';
  String get somethingWentWrong =>
      isFrench ? 'Une erreur est survenue.' : 'Something went wrong.';

  String get notNow => isFrench ? 'Pas maintenant' : 'Not now';
  String get continueAction => isFrench ? 'Continuer' : 'Continue';

  String get extractText => isFrench ? 'Extraire le texte' : 'Extract text';
  String get extractTextSubtitle => isFrench
      ? 'Depuis une image ou un PDF'
      : 'From an image or PDF';
  String get chooseFileForOcr => isFrench
      ? 'Choisir un fichier à analyser'
      : 'Choose a file to extract text from';
  String get ocrPrimerExplanation => isFrench
      ? 'Choisissez une image ou un PDF. Seul ce fichier sera envoyé à Chekkam pour en extraire le texte.'
      : 'Pick an image or PDF. Only that one file is sent to Chekkam to extract its text.';
  String get ocrUploadIntro => isFrench
      ? "Importez une capture d'écran, une photo ou un PDF. Chekkam en extrait le texte pour vous."
      : "Upload a screenshot, photo, or PDF. Chekkam extracts its text for you.";
  String get ocrProcessing => isFrench
      ? 'Téléversement et analyse en cours…'
      : 'Uploading and analyzing…';
  String get ocrHistory =>
      isFrench ? 'Historique des extractions' : 'OCR history';
  String get ocrResult => isFrench ? "Résultat de l'extraction" : 'OCR result';
  String get extractedText =>
      isFrench ? 'TEXTE EXTRAIT' : 'EXTRACTED TEXT';
  String get copyText => isFrench ? 'Copier' : 'Copy';
  String get shareText => isFrench ? 'Partager' : 'Share';
  String get copiedToClipboard =>
      isFrench ? 'Copié dans le presse-papiers.' : 'Copied to clipboard.';
  String get noOcrHistory => isFrench
      ? "Aucune extraction pour l'instant."
      : 'No OCR extractions yet.';

  String confidenceLabel(String level) {
    return switch (level) {
      'high' => isFrench ? 'Confiance élevée' : 'High confidence',
      'medium' => isFrench ? 'Confiance moyenne' : 'Medium confidence',
      _ => isFrench ? 'Confiance faible' : 'Low confidence',
    };
  }

  String get ocrStatusDone => isFrench ? 'Terminé' : 'Done';
  String get ocrStatusUnavailable =>
      isFrench ? 'Indisponible' : 'Unavailable';
  String get ocrStatusFailed => isFrench ? 'Échec' : 'Failed';

  String get ocrDoneHeadline =>
      isFrench ? "Texte extrait avec succès." : 'Text extracted successfully.';
  String get ocrDoneGuidance => isFrench
      ? "Ce texte a été extrait automatiquement et peut contenir des erreurs, surtout sur les photos peu nettes."
      : 'This text was extracted automatically and may contain mistakes, especially on unclear photos.';
  String get ocrUnavailableHeadline =>
      isFrench ? "Extraction indisponible pour le moment." : 'Extraction is unavailable right now.';
  String get ocrUnavailableGuidance => isFrench
      ? "Le service d'extraction n'est pas configuré ou temporairement indisponible. Réessayez plus tard."
      : "The extraction service isn't configured or is temporarily unavailable. Please try again later.";
  String get ocrFailedHeadline =>
      isFrench ? "L'extraction a échoué." : 'Extraction failed.';
  String get ocrFailedGuidance => isFrench
      ? "Une erreur inattendue est survenue avec ce fichier. Essayez un autre fichier ou réessayez plus tard."
      : 'Something unexpected went wrong with this file. Try a different file or try again later.';

  String ocrStatusForHistory(String status) {
    return switch (status) {
      'done' => ocrStatusDone,
      'unavailable' => ocrStatusUnavailable,
      _ => ocrStatusFailed,
    };
  }

  String get suspiciousPhrases =>
      isFrench ? 'PASSAGES SUSPECTS' : 'SUSPICIOUS PHRASES';
  String get ocrNoTextFound => isFrench
      ? "Aucun texte n'a pu être extrait de cette image."
      : "No text could be extracted from that image.";
  String similarReportsFound(int count) {
    if (isFrench) {
      return count == 1
          ? '1 signalement similaire trouvé'
          : '$count signalements similaires trouvés';
    }
    return count == 1
        ? '1 similar report found'
        : '$count similar reports found';
  }

  String get apiConnectionError => isFrench
      ? 'Impossible de joindre le serveur Chekkam. Vérifiez votre connexion et réessayez.'
      : 'Could not reach the Chekkam server. Check your connection and try again.';
  String get apiUnexpectedResponse => isFrench
      ? 'Le serveur a renvoyé une réponse inattendue.'
      : 'The server returned an unexpected response.';
  String get apiGenericError => isFrench
      ? 'Une erreur est survenue. Veuillez réessayer.'
      : 'Something went wrong. Please try again.';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
