const API = '/movies';
async function loadMovies(){
  const res = await fetch(API);
  const movies = await res.json();
  const root = document.getElementById('movies');
  root.innerHTML = '';
  movies.forEach(m=>{
    const div = document.createElement('div');
    div.className='movie';
    div.innerHTML = `<strong>${m.title} (${m.year})</strong><br/>${m.genre||''}
      <form onsubmit="addReview(event,${m.id})">
        <input id="rating-${m.id}" placeholder="Nota 1-10" required />
        <input id="comment-${m.id}" placeholder="Comentário" />
        <button type="submit">Avaliar</button>
      </form>
      <button onclick="showReviews(${m.id})">Ver avaliações</button>
      <div id="reviews-${m.id}"></div>`;
    root.appendChild(div);
  });
}
document.getElementById('movieForm').addEventListener('submit', async e=>{
  e.preventDefault();
  const title=document.getElementById('title').value;
  const year=document.getElementById('year').value;
  const genre=document.getElementById('genre').value;
  await fetch(API,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({title,year,genre})});
  e.target.reset(); loadMovies();
});
async function addReview(e,id){ e.preventDefault();
  const rating=document.getElementById(`rating-${id}`).value;
  const comment=document.getElementById(`comment-${id}`).value;
  await fetch(`/movies/${id}/reviews`,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({rating,comment})});
  showReviews(id);
}
async function showReviews(id){
  const res=await fetch(`/movies/${id}/reviews`);
  const data=await res.json();
  document.getElementById(`reviews-${id}`).innerHTML = '<ul>'+data.map(r=>`<li>Nota: ${r.rating} - ${r.comment||''}</li>`).join('')+'</ul>';
}
loadMovies();
