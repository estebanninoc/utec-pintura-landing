const {chromium}=require('/tmp/pw/node_modules/playwright');
const fs=require('fs');
const [,,port,N,outdir,set]=process.argv;
(async()=>{
  const b=await chromium.launch({executablePath:process.env.HOME+'/.cache/ms-playwright/chromium-1248/chrome-linux64/chrome'});
  const p=await b.newPage({viewport:{width:1600,height:1100}});
  await p.goto('http://127.0.0.1:'+port+'/render.html?set='+(set||'taller')); await p.evaluate(()=>window.ready);
  fs.mkdirSync(outdir,{recursive:true});
  for(let k=1;k<=+N;k++){
    const d=await p.evaluate(([k,N])=>frame(k,N),[k,+N]);
    fs.writeFileSync(outdir+'/f_'+String(k).padStart(3,'0')+'.jpg',Buffer.from(d.split(',')[1],'base64'));
  }
  await b.close(); console.log('ok',N,outdir);
})();
