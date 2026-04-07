enum AiChatRoute { internal, faqs, web, clarification, unknown }

AiChatRoute aiChatRouteFromApi(String? value) {
  switch ((value ?? '').toUpperCase().trim()) {
    case 'INTERNAL':
      return AiChatRoute.internal;
    case 'FAQ':
    case 'FAQs':
      return AiChatRoute.faqs;
    case 'WEB':
      return AiChatRoute.web;
    case 'CLARIFICATION':
      return AiChatRoute.clarification;
    default:
      return AiChatRoute.unknown;
  }
}
