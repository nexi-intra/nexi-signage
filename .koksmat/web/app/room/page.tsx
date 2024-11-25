
import Link from 'next/link'
import React from 'react'

export default function Page() {
  return (
    <div>
      <div>Rooms</div>
      <Link className='text-blue-500 hover:underline' href="/room/1">Room 1</Link>
    </div>
  )
}
