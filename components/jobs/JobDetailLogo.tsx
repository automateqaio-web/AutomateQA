"use client";

import { useState } from "react";

const DOMAIN_OVERRIDES: Record<string, string> = {
  "tata consultancy services": "tcs.com", "tcs": "tcs.com",
  "wipro": "wipro.com", "infosys": "infosys.com",
  "hcl technologies": "hcltech.com", "tech mahindra": "techmahindra.com",
  "ltimindtree": "ltimindtree.com", "lti mindtree": "ltimindtree.com",
  "cognizant": "cognizant.com", "capgemini": "capgemini.com",
  "accenture": "accenture.com", "ibm": "ibm.com",
  "google": "google.com", "microsoft": "microsoft.com",
  "amazon": "amazon.com", "meta": "meta.com",
  "netflix": "netflix.com", "flipkart": "flipkart.com",
  "atlassian": "atlassian.com", "zensar": "zensar.com",
  "luxoft": "luxoft.com", "epam": "epam.com", "epam systems": "epam.com",
  "randstad": "randstad.com", "randstad digital": "randstad.com",
  "apex systems": "apexsystems.com",
};

function companyDomain(name: string): string {
  const key = name.toLowerCase().replace(/[^a-z0-9\s]/g, " ").trim().replace(/\s+/g, " ");
  for (const [k, v] of Object.entries(DOMAIN_OVERRIDES)) {
    if (key.includes(k)) return v;
  }
  const tld = name.match(/\b(\w+)\.(ai|io|co|app|tech|dev|com|net|org)\b/i);
  if (tld) return `${tld[1]}.${tld[2]}`.toLowerCase();
  const cleaned = name
    .replace(/\b(inc|llc|ltd|pvt|private|limited|corp|corporation|technologies|technology|tech|services|solutions|consulting|consultancy|staffing|group|india|us|usa|uk|digital|systems|software|global|international|infotech|infosolutions|worldwide)\b\.?/gi, " ")
    .replace(/[^a-zA-Z0-9\s]/g, " ").trim().replace(/\s+/g, "").toLowerCase();
  return cleaned ? `${cleaned}.com` : "";
}

export default function JobDetailLogo({ company, colors }: { company: string; colors: [string, string] }) {
  const [srcIdx, setSrcIdx] = useState(0);
  const [loaded, setLoaded] = useState(false);
  const [allFailed, setAllFailed] = useState(false);

  const [c1, c2] = colors;
  const initial = (company[0] || "?").toUpperCase();
  const domain = companyDomain(company);
  const sources = domain
    ? [`https://logo.clearbit.com/${domain}`, `https://www.google.com/s2/favicons?domain=${domain}&sz=128`]
    : [];

  const tryNext = () => {
    if (srcIdx + 1 < sources.length) setSrcIdx(s => s + 1);
    else setAllFailed(true);
  };

  if (!domain || allFailed || sources.length === 0) {
    return (
      <div
        className="w-20 h-20 sm:w-24 sm:h-24 rounded-2xl flex-shrink-0 flex items-center justify-center text-white font-black text-3xl shadow-2xl ring-2 ring-white/10"
        style={{ background: `linear-gradient(135deg,${c1},${c2})` }}
      >
        {initial}
      </div>
    );
  }

  return (
    <div className="relative w-20 h-20 sm:w-24 sm:h-24 rounded-2xl flex-shrink-0 shadow-2xl ring-2 ring-white/10 overflow-hidden">
      {!loaded && (
        <div
          className="absolute inset-0 flex items-center justify-center text-white font-black text-3xl"
          style={{ background: `linear-gradient(135deg,${c1},${c2})` }}
        >
          {initial}
        </div>
      )}
      <div className={`absolute inset-0 bg-white flex items-center justify-center p-2 transition-opacity duration-300 ${loaded ? "opacity-100" : "opacity-0"}`}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          key={srcIdx}
          src={sources[srcIdx]}
          alt={company}
          className="w-full h-full object-contain"
          onLoad={() => setLoaded(true)}
          onError={tryNext}
        />
      </div>
    </div>
  );
}
