const {chromium}=require('playwright');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const http=require('node:http');
(async()=>{
 const server=http.createServer((req,res)=>{res.setHeader('Content-Type','text/html');res.end(fs.readFileSync('index.html'))});
 await new Promise(r=>server.listen(0,'127.0.0.1',r));
 let browser;
 try{
 browser=await chromium.launch({headless:true});
 const page=await browser.newPage({serviceWorkers:'block'});
 page.on('dialog',d=>d.accept());
 await page.goto('http://127.0.0.1:'+server.address().port);
 const result=await page.evaluate(async()=>{
 const entry={id:1,projectId:1,articleId:101,quantity:2,price:100,date:'2026-01-01'};
 const html='<article class="invoice-sheet"><div class="invoice-top"><div>Original seller</div><div>Original buyer</div></div><div class="invoice-meta"><div><span>Fakturanummer</span><strong>100</strong></div></div><table class="invoice-lines"><tbody><tr><td>Work</td><td>2</td><td>100</td><td>25 %</td><td>200</td></tr></tbody></table><div class="invoice-totals"><div class="row">Total 250</div></div></article>';
 const invoice={id:1,status:'issued',customerId:1,entryIds:[1],invoiceNumber:'100',archiveHtml:html,archiveSnapshot:{entries:[structuredClone(entry)],customer:{id:1,name:'Original buyer'}},payments:[{id:1,date:'2026-01-02',amount:250,note:''}]};
 const fixture={customers:[{id:1,name:'Changed buyer'}],projects:[{id:1,customerId:1,name:'Project'}],entries:[{...entry,price:1}],articles:[{id:101,name:'Work'}],company:{name:'Changed seller'},invoices:[invoice]};
 const payload={format:'dolevi-demo-backup',version:'1.9.7',data:fixture};
 const check=(ok,msg)=>{if(!ok)throw Error(msg)};
 const bytes=async i=>Array.from(new Uint8Array(await makeInvoicePdf(i).arrayBuffer()));
 const before=await bytes(invoice);
 check(new TextDecoder().decode(Uint8Array.from(before)).startsWith('%PDF-1.4'),'PDF header');
 check(new TextDecoder().decode(Uint8Array.from(before)).includes('Original buyer'),'PDF historical buyer');
 tab('invoices');
 const restore=async p=>{const file=new File([JSON.stringify(p)],'fixture.json',{type:'application/json'});await prepareRestore({target:{files:[file]}});check(!!$('restoreNow'),'restore accepted');$('restoreConfirm').checked=true;$('restoreNow').click();};
 await restore(payload);
 check(JSON.parse(localStorage.getItem('dolevi-demo-v01')).invoices[0].archiveHtml===html,'stored archive');
 check(receivableTotal(data.invoices[0])===250,'historical gross after restore');
 check(JSON.stringify(await bytes(data.invoices[0]))===JSON.stringify(before),'PDF bytes after restore');
 data.entries[0].price=999;data.customers[0].name='Again changed';
 check(JSON.stringify(await bytes(data.invoices[0]))===JSON.stringify(before),'PDF bytes after edits');
 const invalid=structuredClone(payload);invalid.data.invoices[0].payments[0].amount=251;
 let rejected=false;try{validateBackup(invalid)}catch{rejected=true}check(rejected,'overpayment rejected');
 const legacy=structuredClone(payload);legacy.version='1.8.4';delete legacy.data.invoices[0].archiveSnapshot;delete legacy.data.invoices[0].payments;
 await restore(legacy);check(receivableTotal(data.invoices[0])===null,'legacy unknown total');check(JSON.stringify(await bytes(data.invoices[0]))===JSON.stringify(before),'legacy frozen PDF');
 return 'Backup restore, historical PDF bytes, legacy synthetic fixture and overpayment checks passed';
 });
 console.log(result);
 }finally{if(browser)await browser.close();server.close()}
})().catch(e=>{console.error(e);process.exitCode=1});
