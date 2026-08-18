import { label, t } from "../i18n";
import type { AtlasQuote, Locale } from "../types";

/**
 * A quote card in the manner of an illuminated manuscript: a decorated initial,
 * a vine border drawn from the era colour, and the citation set as a rubric.
 *
 * The decoration is doing editorial work rather than ornament. A biblical
 * saying arrives in a reader's head already detached from its source, so the
 * card puts the reference, the public-domain edition and the verified source
 * link inside the same frame as the words. The border is inline SVG keyed on
 * the era accent, so it costs no assets and follows the timeline's palette.
 */

const round = (value: number): string => (Math.round(value * 100) / 100).toString();

/** A vine that grows down the left rule; deterministic from the quote id. */
function vine(accent: string, seedText: string): React.ReactNode {
  let seed = 0;
  for (const character of seedText) seed = Math.imul(seed ^ character.codePointAt(0)!, 2654435761) >>> 0;
  const next = (): number => {
    seed = (seed + 0x6d2b79f5) >>> 0;
    let value = seed;
    value = Math.imul(value ^ (value >>> 15), value | 1);
    value ^= value + Math.imul(value ^ (value >>> 7), value | 61);
    return ((value ^ (value >>> 14)) >>> 0) / 4294967296;
  };
  const leaves = Array.from({ length: 6 }, (_, index) => {
    const y = 12 + index * 16;
    const side = index % 2 === 0 ? 1 : -1;
    const reach = 4 + next() * 3;
    return `M6 ${y} q${side * reach} -3 ${side * reach} -6 q${-side * reach} 3 ${-side * reach} 6z`;
  }).join(" ");
  return <svg className="quote-vine" viewBox="0 0 12 108" preserveAspectRatio="none" aria-hidden="true">
    <path d="M6 2 C2 20 10 38 6 56 C2 74 10 90 6 106" fill="none" stroke={accent} strokeWidth="1.6" strokeLinecap="round" opacity="0.85" />
    <path d={leaves} fill={accent} opacity="0.45" />
    <circle cx="6" cy="2" r={round(1.8)} fill={accent} opacity="0.7" />
  </svg>;
}

interface Props {
  quote: AtlasQuote;
  accent: string;
  locale: Locale;
  /** Optional jump back to the event the saying belongs to. */
  onEvent?: (() => void) | undefined;
  eventTitle?: string | undefined;
}

export function IlluminatedQuote({ quote, accent, locale, onEvent, eventTitle }: Props) {
  // The CUV was published in traditional characters; say so rather than
  // silently converting a 1919 edition into a script it was not printed in.
  const traditional = quote.scriptVariant === "han-traditional";
  /*
   * An illuminated initial is a Latin device and needs a capital letter to be
   * one. Chinese has no case, its glyphs are full-width, and a cut excerpt
   * often opens on a function word — a 2.5rem gold 「其」 puts the visual stress
   * on the least meaningful syllable in the sentence. So the Chinese card marks
   * its opening in gold instead, closer to the rubricated head of a sutra
   * column, and the Latin card raises an initial only when there is a capital
   * to raise; otherwise a giant lowercase "i" reads as a rendering bug.
   */
  const characters = [...quote.quoteText];
  const useDropCap = !traditional && locale !== "zh-CN" && /\p{Lu}/u.test(characters[0] ?? "");
  const rubricated = traditional || locale === "zh-CN" ? characters.slice(0, 2).join("") : "";
  const editionNote = quote.translationEdition === "CUV-1919"
    ? (locale === "zh-CN" ? "和合本（1919，繁体）" : "Chinese Union Version (1919, traditional script)")
    : (locale === "zh-CN" ? "World English Bible（公有领域）" : "World English Bible (public domain)");
  return <figure className="illuminated-quote" style={{ ["--quote-accent" as string]: accent }}>
    {vine(accent, quote.id)}
    {/* The opening is split out only to be styled; DOM order still reads as the
        whole sentence, so no duplicate copy is needed for screen readers. */}
    <blockquote lang={traditional ? "zh-Hant" : undefined}>
      {useDropCap
        ? <><span className="drop-cap" style={{ color: accent }}>{characters[0]}</span>{characters.slice(1).join("")}</>
        : rubricated
          ? <><span className="rubric-open" style={{ color: accent }}>{rubricated}</span>{characters.slice(2).join("")}</>
          : quote.quoteText}
    </blockquote>
    <figcaption>
      <span className="quote-reference">
        {quote.referenceLabel}
        {/* Almost every saying here is a cut from a longer verse. Saying
            "checked word for word" without saying "excerpt" would let the
            badge imply the card holds the whole verse. */}
        {quote.isExcerpt && <em className="quote-excerpt">{t("quoteExcerpt", locale)}</em>}
      </span>
      <span className="quote-kind">{label(quote.speechKind, locale)}</span>
      {quote.contextNote && <span className="quote-context">{quote.contextNote}</span>}
      <span className="quote-edition">
        {editionNote}
        {quote.verifiedSourceUrl && <> · <a href={quote.verifiedSourceUrl} target="_blank" rel="noreferrer">{t("verseVerified", locale)} ↗</a></>}
      </span>
      {onEvent && eventTitle && <button type="button" className="link" onClick={onEvent}>{eventTitle}</button>}
    </figcaption>
  </figure>;
}
