import Link from 'next/link'
import React from 'react'

export default function Page(props: { params: { email: string } }) {
  const email = decodeURIComponent(props.params.email)
  return (
    <div>{email}


      <Link className='text-blue-500 hover:underline' href={`/room/${email}/display`}>Room 1</Link>
    </div>
  )
}
