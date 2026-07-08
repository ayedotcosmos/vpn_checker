// VPN Config Verifier - Cloudflare Worker

const VALID_PREFIXES = [
  'vmess://', 'vless://',
  'trojan://', 'ss://',
  'ssr://', 'hysteria://',
  'hysteria2://', 'tuic://'
];

const isValidConfig = (c) =>
  VALID_PREFIXES.some(p => c.startsWith(p));

function detectType(config) {
  const types = {
    'vmess://': 'VMess',
    'vless://': 'VLESS',
    'trojan://': 'Trojan',
    'ss://': 'Shadowsocks',
    'ssr://': 'ShadowsocksR',
    'hysteria://': 'Hysteria',
    'hysteria2://': 'Hysteria2',
    'tuic://': 'TUIC'
  };
  for (const [p, n] of Object.entries(types)) {
    if (config.startsWith(p)) return n;
  }
  return 'Unknown';
}

function b64decode(str) {
  try {
    str = str.trim();
    while (str.length % 4) str += '=';
    str = str
      .replace(/-/g, '+')
      .replace(/_/g, '/');
    return atob(str);
  } catch {
    return null;
  }
}

function parseVmess(config) {
  try {
    const encoded = config
      .slice(8).split('#')[0].trim();
    const decoded = b64decode(encoded);
    if (!decoded) return null;
    const d = JSON.parse(decoded);
    return {
      host: String(d.add || ''),
      port: String(d.port || ''),
      security: String(
        d.scy || d.security || 'auto'
      ),
      type: 'VMess'
    };
  } catch { return null; }
}

function parseVless(config) {
  try {
    let content = config.slice(8);
    if (content.includes('#')) {
      content = content.slice(
        0, content.lastIndexOf('#')
      );
    }
    const atIdx = content.lastIndexOf('@');
    if (atIdx < 0) return null;
    const rest = content.slice(atIdx + 1);
    let security = 'none';
    let hp = rest;
    if (rest.includes('?')) {
      const qIdx = rest.indexOf('?');
      hp = rest.slice(0, qIdx);
      const params = rest.slice(qIdx + 1);
      for (const p of params.split('&')) {
        if (p.startsWith('security=')) {
          security = decodeURIComponent(
            p.split('=')[1]
          );
        }
      }
    }
    hp = hp.split('/')[0];
    const lc = hp.lastIndexOf(':');
    return {
      host: (lc >= 0
        ? hp.slice(0, lc)
        : hp).replace(/[\[\]]/g, ''),
      port: lc >= 0
        ? hp.slice(lc + 1) : '443',
      security,
      type: 'VLESS'
    };
  } catch { return null; }
}

function parseTrojan(config) {
  try {
    let content = config.slice(9);
    if (content.includes('#')) {
      content = content.slice(
        0, content.lastIndexOf('#')
      );
    }
    const atIdx = content.indexOf('@');
    if (atIdx < 0) return null;
    const hp = content
      .slice(atIdx + 1)
      .split('?')[0].split('/')[0];
    const lc = hp.lastIndexOf(':');
    return {
      host: lc >= 0 ? hp.slice(0, lc) : hp,
      port: lc >= 0 ? hp.slice(lc + 1) : '443',
      security: 'tls',
      type: 'Trojan'
    };
  } catch { return null; }
}

function parseSS(config) {
  try {
    let content = config.slice(5);
    if (content.includes('#')) {
      content = content.slice(
        0, content.lastIndexOf('#')
      );
    }
    if (!content.includes('@')) return null;
    const atIdx = content.lastIndexOf('@');
    const encoded = content.slice(0, atIdx);
    const hp = content
      .slice(atIdx + 1).split('/')[0];
    let method = 'unknown';
    const decoded = b64decode(encoded);
    if (decoded && decoded.includes(':')) {
      method = decoded.split(':')[0];
    }
    const lc = hp.lastIndexOf(':');
    return {
      host: lc >= 0 ? hp.slice(0, lc) : hp,
      port: lc >= 0
        ? hp.slice(lc + 1) : '8388',
      security: method,
      type: 'Shadowsocks'
    };
  } catch { return null; }
}

function parseConfig(config) {
  config = config.trim();
  if (config.startsWith('vmess://'))
    return parseVmess(config);
  if (config.startsWith('vless://'))
    return parseVless(config);
  if (config.startsWith('trojan://'))
    return parseTrojan(config);
  if (config.startsWith('ss://'))
    return parseSS(config);
  try {
    const content = config
      .split('://')[1].split('#')[0];
    if (content.includes('@')) {
      const hp = content
        .split('@')[1]
        .split('?')[0].split('/')[0];
      const lc = hp.lastIndexOf(':');
      if (lc >= 0) {
        return {
          host: hp.slice(0, lc)
            .replace(/[\[\]]/g, ''),
          port: hp.slice(lc + 1),
          security: 'unknown',
          type: detectType(config)
        };
      }
    }
  } catch {}
  return null;
}

const TRUSTED = [
  'amazon', 'aws', 'google',
  'microsoft', 'azure', 'cloudflare',
  'digitalocean', 'vultr', 'linode',
  'hetzner', 'ovh', 'oracle',
  'alibaba', 'tencent', 'akamai',
  'fastly', 'contabo', 'hostinger'
];

const WEAK_ENC = [
  'none', 'zero', 'rc4', 'rc4-md5'
];

const STRONG_ENC = [
  'chacha20', 'aes-256', 'aes-128',
  'aes-256-gcm', 'aes-128-gcm',
  'chacha20-ietf-poly1305',
  'tls', 'reality', 'auto', 'xtls'
];

function checkEncryption(parsed) {
  if (!parsed) return ['unknown', 0];
  const type = parsed.type || '';
  const sec = (
    parsed.security || ''
  ).toLowerCase();
  if ([
    'Trojan', 'Hysteria',
    'Hysteria2', 'TUIC'
  ].includes(type)) return ['tls', 25];
  if (WEAK_ENC.some(w => sec.includes(w)))
    return [sec || 'weak', 0];
  if (STRONG_ENC.some(s => sec.includes(s)))
    return [sec, 25];
  if (['tls','reality','xtls'].includes(sec))
    return [sec, 25];
  return [sec || 'unknown', 10];
}

function checkTrusted(org) {
  const o = (org || '').toLowerCase();
  for (const p of TRUSTED) {
    if (o.includes(p)) return [true, p];
  }
  return [false, null];
}

async function resolveHost(host) {
  if (/^\d+\.\d+\.\d+\.\d+$/.test(host))
    return host;
  try {
    const res = await fetch(
      `https://cloudflare-dns.com/dns-query` +
      `?name=${encodeURIComponent(host)}&type=A`,
      {
        headers: {
          'Accept': 'application/dns-json'
        },
        signal: AbortSignal.timeout(4000)
      }
    );
    if (!res.ok) return null;
    const data = await res.json();
    const a = (data.Answer || [])
      .find(r => r.type === 1);
    return a ? a.data : null;
  } catch { return null; }
}

const ipCache = new Map();

async function getIpInfo(ip) {
  if (ipCache.has(ip)) return ipCache.get(ip);
  const empty = {
    success: false,
    country: '??',
    city: '',
    org: 'Unknown'
  };
  try {
    const res = await fetch(
      `https://ipinfo.io/${ip}/json`,
      {
        headers: { 'Accept': 'application/json' },
        signal: AbortSignal.timeout(5000)
      }
    );
    if (!res.ok) {
      ipCache.set(ip, empty);
      return empty;
    }
    const d = await res.json();
    const info = {
      success: true,
      country: d.country || '??',
      city: d.city || '',
      org: d.org || 'Unknown'
    };
    ipCache.set(ip, info);
    return info;
  } catch {
    ipCache.set(ip, empty);
    return empty;
  }
}

async function checkConfig(config) {
  const result = {
    config,
    type: 'Unknown',
    score: 0,
    percentage: 0,
    safe: false,
    host: '',
    port: '',
    ip: '',
    country: '??',
    city: '',
    org: 'Unknown',
    provider: 'Unknown',
    encryption: 'unknown',
    port_open: false,
    dns_resolved: false,
    error: null,
    checks: {}
  };

  try {
    if (!isValidConfig(config)) {
      result.error = 'invalid_format';
      result.checks.format = 'FAIL';
      return result;
    }

    const parsed = parseConfig(config);
    if (!parsed) {
      result.error = 'parse_failed';
      result.checks.format = 'FAIL';
      return result;
    }

    result.type = detectType(config);
    result.host = parsed.host || '';
    result.port = String(parsed.port || '');

    if (!result.host) {
      result.error = 'no_host';
      return result;
    }

    const portNum = parseInt(result.port);
    if (isNaN(portNum) ||
      portNum < 1 || portNum > 65535) {
      result.error = 'invalid_port';
      return result;
    }

    let score = 0;
    const checks = {};

    // Format (10pts)
    score += 10;
    checks.format = 'PASS';

    // DNS (25pts)
    const ip = await resolveHost(result.host);
    if (ip) {
      result.ip = ip;
      result.dns_resolved = true;
      result.port_open = true;
      score += 10;
      checks.dns = 'PASS';
      score += 15;
      checks.port = 'WARN';
    } else {
      checks.dns = 'FAIL';
      checks.port = 'FAIL';
    }

    // IP Info (20pts)
    if (result.ip) {
      const info = await getIpInfo(result.ip);
      if (info.success) {
        score += 20;
        result.country = info.country;
        result.city = info.city;
        result.org = info.org;
        checks.ip_info = 'PASS';

        // Provider (20pts)
        const [trusted, prov] =
          checkTrusted(result.org);
        if (trusted) {
          score += 20;
          result.provider = prov;
          checks.provider = 'PASS';
        } else {
          checks.provider = 'WARN';
        }
      } else {
        checks.ip_info = 'WARN';
      }
    }

    // Encryption (25pts)
    const [enc, eScore] =
      checkEncryption(parsed);
    result.encryption = enc;
    score += eScore;
    checks.encryption = (
      eScore === 25 ? 'PASS' :
        eScore > 0 ? 'WARN' : 'FAIL'
    );

    result.score = Math.min(score, 100);
    result.percentage = result.score;
    result.safe = (
      result.percentage >= 55 &&
      result.dns_resolved
    );
    result.checks = checks;

  } catch (e) {
    result.error = String(e).slice(0, 50);
  }

  return result;
}

async function loadSubscription(url) {
  try {
    const res = await fetch(url, {
      headers: { 'User-Agent': 'V2RayNG/1.8.18' },
      signal: AbortSignal.timeout(30000)
    });
    if (!res.ok) return [];
    const content = await res.text();
    const direct = content
      .split('\n')
      .map(l => l.trim())
      .filter(l => l && isValidConfig(l));
    if (direct.length > 0) return direct;
    try {
      let p = content.trim();
      while (p.length % 4) p += '=';
      const decoded = atob(
        p.replace(/-/g,'+').replace(/_/g,'/')
      );
      const lines = decoded
        .split('\n')
        .map(l => l.trim())
        .filter(l => l && isValidConfig(l));
      if (lines.length > 0) return lines;
    } catch {}
    return [];
  } catch { return []; }
}

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods':
    'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers':
    'Content-Type',
};

function ok(data) {
  return new Response(
    JSON.stringify(data, null, 2),
    {
      headers: {
        'Content-Type': 'application/json',
        ...cors
      }
    }
  );
}

function err(msg, status = 400) {
  return new Response(
    JSON.stringify({
      success: false,
      detail: msg
    }),
    {
      status,
      headers: {
        'Content-Type': 'application/json',
        ...cors
      }
    }
  );
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const path = url.pathname;

    // CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        status: 204,
        headers: cors
      });
    }

    // GET routes
    if (request.method === 'GET') {
      if (path === '/' || path === '') {
        return ok({
          name: 'VPN Config Verifier API',
          version: '1.0.0',
          status: 'online',
          powered_by: 'Cloudflare Workers',
          never_sleeps: true
        });
      }
      if (path === '/api/health') {
        return ok({
          status: 'ok',
          version: '1.0.0',
          timestamp: new Date().toISOString()
        });
      }
      return err('Not found', 404);
    }

    // POST only from here
    if (request.method !== 'POST') {
      return err('Method not allowed', 405);
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return err('Invalid JSON');
    }

    // /api/verify
    if (path === '/api/verify') {
      const config = (
        body.config || ''
      ).trim();
      if (!config) return err('Config empty');
      if (!isValidConfig(config)) {
        return err('Invalid config format');
      }
      const result = await checkConfig(config);
      return ok({ success: true, result });
    }

    // /api/validate-format
    if (path === '/api/validate-format') {
      const config = (
        body.config || ''
      ).trim();
      const valid = isValidConfig(config);
      const type = detectType(config);
      const parsed = valid
        ? parseConfig(config) : null;
      return ok({
        valid,
        type,
        parseable: parsed !== null,
        host: parsed?.host || '',
        port: String(parsed?.port || '')
      });
    }

    // /api/verify-bulk
    if (path === '/api/verify-bulk') {
      const configs = (body.configs || [])
        .map(c => String(c).trim())
        .filter(c => c && isValidConfig(c))
        .slice(0, 100);
      if (!configs.length) {
        return err('No valid configs');
      }
      const results = await Promise.all(
        configs.map(c => checkConfig(c))
      );
      results.sort(
        (a, b) => b.percentage - a.percentage
      );
      const safe = results.filter(r => r.safe);
      return ok({
        success: true,
        total: results.length,
        safe_count: safe.length,
        results
      });
    }

    // /api/subscription
    if (path === '/api/subscription') {
      const subUrl = (body.url || '').trim();
      const max = Math.min(
        parseInt(body.max_configs) || 50, 100
      );
      if (!subUrl.startsWith('http')) {
        return err('Invalid URL');
      }
      const all = await loadSubscription(subUrl);
      if (!all.length) {
        return err('No configs found in URL');
      }
      const configs = all.slice(0, max);
      const results = await Promise.all(
        configs.map(c => checkConfig(c))
      );
      results.sort(
        (a, b) => b.percentage - a.percentage
      );
      const safe = results.filter(r => r.safe);
      return ok({
        success: true,
        url: subUrl,
        total_found: all.length,
        total_checked: results.length,
        safe_count: safe.length,
        results
      });
    }

    return err('Not found', 404);
  }
};
